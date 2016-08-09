class TransType < ActiveRecord::Base
  establish_connection TRENDS_DB

  belongs_to :detail_summary
end
