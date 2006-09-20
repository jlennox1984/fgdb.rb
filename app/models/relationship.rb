require 'ajax_scaffold'

class Relationship < ActiveRecord::Base
  belongs_to :relationship_type
  belongs_to :source, :foreign_key => "source_id", :class_name => "Contact"
  belongs_to :sink,   :foreign_key => "sink_id",   :class_name => "Contact"
  # acts_as_userstamp
end
