class Artist < ActiveRecord::Base
  establish_connection TUNECORE_DB

  has_many :creatives
end
