class Album < ActiveRecord::Base
  self.establish_connection :operational
  has_many :creatives, as: :creativeable
end
