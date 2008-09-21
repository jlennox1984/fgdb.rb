class ContactDuplicate < ActiveRecord::Base
  belongs_to :contact

  def self.list_dups()
    dups = self.connection.execute("
      SELECT dup_check, count(*)
      FROM contact_duplicates
      GROUP BY dup_check
      ORDER BY dup_check
    ").map{|x| [x["dup_check"],x["count"]]}

    return dups.collect{|x|x}
  end
end