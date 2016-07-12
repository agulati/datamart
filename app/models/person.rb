class Person < ActiveRecord::Base
  establish_connection :operational
  has_many :albums

  def self.exclude_ids
    [687143, 750492]
  end
end
