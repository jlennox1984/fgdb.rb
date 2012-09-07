class Schedule < ActiveRecord::Base
  acts_as_nested_set
  has_many :standard_shifts
  has_many :holidays
  has_many :meetings
  has_many :work_shifts

  def self.generate_from
    find_by_generate_from(true)
  end

  def self.reference_from
    find_by_reference_from(true)
  end

  def copy(newname)
    newsched = self.clone
    newsched.name = newname
    newsched.generate_from = false
    newsched.save!
    self.standard_shifts.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    self.meetings.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    self.holidays.each do |x|
      y = x.clone
      y.schedule = newsched
      y.save!
    end
    self.children.each do |x|
      y = x.copy(newname + " " + x.name)
      y.move_to_child_of(newsched)
      y.save!
    end
    return newsched
  end

  def which_week( date = Date.today.to_date )
    if self.repeats_every > 1
      long_time_ago = Date.new(1901, 12, 22)
      difference = (date - long_time_ago).to_int
      ((difference / 7) % self.repeats_every )
    else
      0
    end
  end

  def shows_on?( date = Date.today.to_date )
    # not sure if this works
    ret = true
    if self.repeats_every > 1
      long_time_ago = Date.new(1901, 12, 22)
      difference = (date - long_time_ago).to_int
      mod = ((difference / 7) % self.repeats_every )
      if mod != self.repeats_on
        ret = false
      end 
    end
    ret
  end

  def relatives
    ret = 'ahem! '
    self.self_and_siblings do |relative|
      ret += (relative.id.to_s + ', ')
    end
    self.parent do |relative|
      ret += (relative.id.to_s + ', ')
    end
    self.children do |relative|
      ret += (relative.id.to_s + ', ')
    end
    ret
  end

  def self.root_nodes
    find(:all, :conditions => 'parent_id IS NULL')
  end

  def self.find_children(start_id = nil)
    start_id.to_i == 0 ? root_nodes : find(start_id).direct_children
  end

  def in_clause
    # returns a sql ready string in parens, a comma delimited list of ids
    # such as "(50)"
    ret = '('
    ret += self.id.to_s
    ret += ')'
  end

  def full_name
    ret = self.name
    if not self.root?
      ret += ' [' + self.root.name + ']'
    end
    ret
  end

  def date_range
    start_date = Date.new(1972, 11, 7)
    end_date = Date.new(1973, 2, 2)
    (start_date..end_date)
  end

end
