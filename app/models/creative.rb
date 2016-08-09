class Creative < ActiveRecord::Base
  establish_connection TUNECORE_DB

  belongs_to :creativeable, polymorphic: true
  belongs_to :artist
end
