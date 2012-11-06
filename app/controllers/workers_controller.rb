class WorkersController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['manage_workers']}
    a
  end
  public

  def index
    list
    render :action => 'list'
  end

  def badge
    if params[:workers]
      @workers = Worker.find_all_by_id(params[:workers].map{|x| x.first.to_i}).sort_by(&:name)
    end
  end

  def upload
    @worker = Worker.find_by_id(params[:id])
    dir = RAILS_ROOT + "/public/images/workers/"
    filename = dir + "#{@worker.id}.png"
    if !File.writable?(dir)
      @error = "Cannot write to #{filename}"
    end
    if @error.nil? && (io = params[:picture])
      File.unlink(filename) if File.exists?(filename)
      File.open(filename, 'w') do |f|
        f.write(io.read)
      end
    end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @workers = Worker.paginate :order => 'name', :per_page => 20, :page => params[:page]
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(params[:worker])
    @worker.salaried = _parse_checkbox(params[:worker][:salaried])
    if @worker.save
      flash[:notice] = 'Worker was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @worker = Worker.find(params[:id])
    session["shift_return_to"] = "workers"
    session["shift_return_action"] = "edit"
    session["shift_return_id"] = @worker.id 
  end
  protected
  def _parse_checkbox(val)
    val = val.to_s
    if val == "1"
      return true
    elsif val == "0"
      return false
    else
      return nil
    end
  end
  public
  def update
    @worker = Worker.find(params[:id])
    @worker.salaried = _parse_checkbox(params[:worker][:salaried])
    if @worker.update_attributes(params[:worker])
      flash[:notice] = 'Worker was successfully updated.'
      redirect_to :action => 'show', :id => @worker
    else
      render :action => 'edit'
    end
  end

  def destroy
    Worker.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
