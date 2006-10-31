require 'ajax_scaffold'

class VolunteerTask < ActiveRecord::Base
  has_and_belongs_to_many :volunteer_task_types
  belongs_to  :contact, :order => "surname, first_name"

  def effective_duration
    mult = volunteer_task_types.inject(1) do |mu,type|
      mu *= type.hours_multiplier
    end
    duration * mult
  end
end
