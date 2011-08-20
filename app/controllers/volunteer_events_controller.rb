class VolunteerEventsController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['admin_skedjul']}
    a
  end
  public
  layout :with_sidebar

  def index
    @volunteer_events = VolunteerEvent.find(:all)
  end

  def add_shift
    @ve = VolunteerEvent.find(params[:id])
    vs = VolunteerShift.new
#    vs.slot_count = 1
    vs.volunteer_event_id = @ve.id
    vs.volunteer_event = @ve
    a = Assignment.new
    a.volunteer_shift = vs
    vs.stuck_to_assignment = vs.not_numbered = true
    @assignments = vs.assignments = [a]
    @referer = request.env["HTTP_REFERER"]
    a.volunteer_shift.volunteer_event = @ve
    a.volunteer_shift.stuck_to_assignment = a.volunteer_shift.not_numbered = true
    @my_url = {:action => "create_shift", :id => params[:id]}
    @assignment = a
    render :template => 'assignments/edit'
  end

  def create_shift
    @ve = VolunteerEvent.find(params[:id])
    vs = VolunteerShift.new
    vs.volunteer_event_id = @ve.id
    vs.volunteer_event = @ve
    a = Assignment.new
    a.volunteer_shift = vs
    a.attributes = params[:assignment]
    vs.stuck_to_assignment = vs.not_numbered = true
    @assignments = vs.assignments = [a]
    rt = params[:assignment].delete(:redirect_to)
    @my_url = {:action => "create_shift", :id => params[:id]}
    @assignment = a
    a.volunteer_shift.stuck_to_assignment = a.volunteer_shift.not_numbered = true
    a.volunteer_shift.volunteer_event = @ve
    if @assignment.save # and @assignment.volunteer_shift.save
      redirect_skedj(rt, @ve.date_anchor)
    else
      render :template => 'assignments/edit'
    end
  end

  def show
    @volunteer_event = VolunteerEvent.find(params[:id])
  end

  def new_class
    @notice = ""
    c = params[:klass]
    if c.nil?
      render :action => "new_class"
      return
    end
    c[:contact_id] = params["contact"]["id"] if params["contact"] and params["contact"]["id"]
    normal = c[:student_slot_count].to_i || 0
    instructor = c[:instructor_slot_count].to_i || 0
    audit = c[:audit_slot_count].to_i || 0
    roster = Roster.find_by_id(c[:roster_id].to_i)
    program = Program.find_by_id(c[:program_id].to_i)
    resource = Resource.find_by_id(c[:resource_id].to_i)
    contact = Contact.find_by_id(c[:contact_id].to_i)
#    if roster.nil? or program.nil?
#      redirect_to :action => "new_class"
#      return
#    end
    start_hour = c["start_time(4i)"].to_i
    start_minute = c["start_time(5i)"].to_i
    if c["start_time(7i)"].to_i == ActionView::Helpers::DateTimeSelector::PM
      start_hour += 12 unless start_hour == 12
    else
      start_hour -= 12 if start_hour == 12
    end
    start_time = Time.parse([start_hour, start_minute].join(":"))
    end_hour = c["end_time(4i)"].to_i
    end_minute = c["end_time(5i)"].to_i
    if c["end_time(7i)"].to_i == ActionView::Helpers::DateTimeSelector::PM
      end_hour += 12 unless end_hour == 12
    else
      end_hour -= 12 if end_hour == 12
    end
    end_time = Time.parse([end_hour, end_minute].join(":"))
    c["start_time"] = start_time
    c["end_time"] = end_time
    c["program"] = program
    c["roster"] = roster
    c["resource"] = resource
    params["contact"] ||= {}
    params["contact"]["id"] = contact.id if contact
    @volunteer_event = VolunteerEvent.new
    @volunteer_event.description = c[:description]
    @volunteer_event.date = c[:date]
    @volunteer_event.notes = c[:notes]
    inst_shift = nil
    normal.times do |i|
      a = VolunteerShift.new
      a.class_credit = true
      a.roster_id = roster.id if roster
      a.program_id = program.id if program
      a.slot_number = (i + 1) # starts 0
      a.start_time = start_time
      a.end_time = end_time
      @volunteer_event.volunteer_shifts << a
    end
    audit.times do |i|
      a = VolunteerShift.new
      a.class_credit = false
      a.description = "AUDIT"
      a.roster_id = roster.id if roster
      a.program_id = program.id if program
      a.slot_number = (normal + i + 1) # starts 0
      a.start_time = start_time
      a.end_time = end_time
      @volunteer_event.volunteer_shifts << a
    end
    instructor.times do |i|
      a = VolunteerShift.new
      a.class_credit = false
      a.volunteer_task_type = VolunteerTaskType.find_by_name("teaching")
      a.slot_number = (i + 1)
      a.roster_id = roster.id if roster
      a.program_id = program.id if program
      a.start_time = start_time
      a.end_time = end_time
      a.volunteer_event = @volunteer_event
      if contact and i == 0
        inst_shift = a
      end
      @volunteer_event.volunteer_shifts << a
    end
    if resource
      a = ResourcesVolunteerEvent.new
      a.resource = resource
      a.roster_id = roster.id if roster
      a.start_time = start_time
      a.end_time = end_time
      @volunteer_event.resources_volunteer_events << a
    end
    if @volunteer_event.save
      if inst_shift
        a = inst_shift.assignments.first
        a.contact_id = contact.id
        a.save
      end
      @volunteer_event = VolunteerEvent.new
      @notice = "\"#{c[:description]}\" created successfully"
      render :action => "new_class"
    else
      def c.method_missing(sym)
        self[sym]
      end
      @klass = c
      render :action => "new_class"
    end
  end

  def new
    @volunteer_event = VolunteerEvent.new
  end

  def copy
    redirect_to :action => "show", :id => VolunteerEvent.find_by_id(params[:id]).copy_to(Date.parse(params[:copy][:date]), hours_val(params[:copy])).id
  end

  def edit
    @volunteer_event = VolunteerEvent.find(params[:id])
    @referer = request.env["HTTP_REFERER"]
  end

  def create
    @volunteer_event = VolunteerEvent.new(params[:volunteer_event])

    _save
    if @volunteer_event.save
      _after_save
      flash[:notice] = 'VolunteerEvent was successfully created.'
      redirect_to({:action => "show", :id => @volunteer_event.id})
    else
      render :action => "new"
    end
  end

  def update
    @volunteer_event = VolunteerEvent.find(params[:id])
    rt = params[:volunteer_event].delete(:redirect_to)

    _save
    if @volunteer_event.update_attributes(params[:volunteer_event])
      _after_save
      flash[:notice] = 'VolunteerEvent was successfully updated.'
      redirect_skedj(rt, @volunteer_event.date_anchor)
    else
      render :action => "edit"
    end
  end

  def _save
    @volunteer_shifts = apply_line_item_data(@volunteer_event, VolunteerShift)
    @resources = apply_line_item_data(@volunteer_event, ResourcesVolunteerEvent)
  end

  def _after_save
    @volunteer_shifts.each{|x| x.save!}
    @resources.each{|x| x.save!}
  end

  def destroy
    @volunteer_event = VolunteerEvent.find(params[:id])
    @volunteer_event.destroy

    redirect_to({:action => "index"})
  end
end
