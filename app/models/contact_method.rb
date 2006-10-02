require 'ajax_scaffold'

class ContactMethod < ActiveRecord::Base
  belongs_to :contact_method_type
  validates_associated :contact_method_type
  belongs_to :contact, :order => "surname, first_name"  
  validates_associated :contact
  # acts_as_userstamp

  def to_s
    description
  end
end
