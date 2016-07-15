class Artist < ActiveRecord::Base
  establish_connection :operational
  has_many :creatives
end
