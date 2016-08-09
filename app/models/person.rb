class Person < ActiveRecord::Base
  establish_connection TUNECORE_DB

  has_many :albums

  def self.exclude_ids
    [687143, 750492]
  end
end
