class Creative < ActiveRecord::Base
  self.establish_connection :operational
  belongs_to :creativeable, polymorphic: true
  belongs_to :artist
end
