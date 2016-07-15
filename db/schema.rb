# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160711163527) do

  create_table "aggregation_log", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "trend_date"
    t.string   "aggregation_type"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "albums_by_date", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "trend_date"
    t.integer  "trend_month"
    t.integer  "trend_year"
    t.integer  "album_id"
    t.string   "album_name"
    t.string   "album_type"
    t.string   "artist_name"
    t.integer  "person_id"
    t.string   "person_name"
    t.string   "email_address"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["album_id"], name: "index_albums_by_date_on_album_id", using: :btree
    t.index ["artist_name"], name: "index_albums_by_date_on_artist_name", using: :btree
    t.index ["country_code"], name: "index_albums_by_date_on_country_code", using: :btree
    t.index ["person_id"], name: "index_albums_by_date_on_person_id", using: :btree
    t.index ["trend_date"], name: "index_albums_by_date_on_trend_date", using: :btree
    t.index ["trend_month"], name: "index_albums_by_date_on_trend_month", using: :btree
    t.index ["trend_year"], name: "index_albums_by_date_on_trend_year", using: :btree
  end

  create_table "albums_by_month", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_month"
    t.string   "trend_month_display"
    t.integer  "trend_year"
    t.integer  "album_id"
    t.string   "album_name"
    t.string   "album_type"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["album_id"], name: "index_albums_by_month_on_album_id", using: :btree
    t.index ["country_code"], name: "index_albums_by_month_on_country_code", using: :btree
    t.index ["trend_month"], name: "index_albums_by_month_on_trend_month", using: :btree
  end

  create_table "albums_by_year", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_year"
    t.integer  "album_id"
    t.string   "album_name"
    t.string   "album_type"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["album_id"], name: "index_albums_by_year_on_album_id", using: :btree
    t.index ["country_code"], name: "index_albums_by_year_on_country_code", using: :btree
    t.index ["trend_year"], name: "index_albums_by_year_on_trend_year", using: :btree
  end

  create_table "artists_by_date", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "trend_date"
    t.string   "artist_name"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["artist_name"], name: "index_artists_by_date_on_artist_name", using: :btree
    t.index ["country_code"], name: "index_artists_by_date_on_country_code", using: :btree
    t.index ["trend_date"], name: "index_artists_by_date_on_trend_date", using: :btree
  end

  create_table "artists_by_month", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_month"
    t.string   "trend_month_display"
    t.string   "artist_name"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["artist_name"], name: "index_artists_by_month_on_artist_name", using: :btree
    t.index ["country_code"], name: "index_artists_by_month_on_country_code", using: :btree
    t.index ["trend_month"], name: "index_artists_by_month_on_trend_month", using: :btree
  end

  create_table "artists_by_year", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_year"
    t.string   "artist_name"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["artist_name"], name: "index_artists_by_year_on_artist_name", using: :btree
    t.index ["country_code"], name: "index_artists_by_year_on_country_code", using: :btree
    t.index ["trend_year"], name: "index_artists_by_year_on_trend_year", using: :btree
  end

  create_table "countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",           limit: 55
    t.string  "code",           limit: 5
    t.boolean "spotify_active"
    t.boolean "amazon_active"
  end

  create_table "geo", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_data_summary_id",                         null: false
    t.string   "country_code",          limit: 2,               null: false
    t.string   "cbsa",                  limit: 5, default: "0", null: false
    t.integer  "qty",                                           null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.date     "date",                                          null: false
    t.index ["cbsa"], name: "index_geo_on_cbsa", using: :btree
    t.index ["country_code"], name: "index_geo_on_country_code", using: :btree
    t.index ["created_at"], name: "index_geo_on_created_at", using: :btree
    t.index ["date", "trend_data_summary_id", "country_code", "cbsa"], name: "by_date_summary_id_country_cbsa", unique: true, using: :btree
    t.index ["date"], name: "index_geo_on_date", using: :btree
    t.index ["trend_data_summary_id"], name: "index_geo_on_trend_data_summary_id", using: :btree
    t.index ["updated_at"], name: "index_geo_on_updated_at", using: :btree
  end

  create_table "geo_two", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_data_summary_id",                         null: false
    t.string   "country_code",          limit: 2,               null: false
    t.string   "cbsa",                  limit: 5, default: "0", null: false
    t.integer  "qty",                                           null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.date     "date",                                          null: false
    t.index ["cbsa"], name: "index_geo_on_cbsa", using: :btree
    t.index ["country_code"], name: "index_geo_on_country_code", using: :btree
    t.index ["created_at"], name: "index_geo_on_created_at", using: :btree
    t.index ["date", "trend_data_summary_id", "country_code", "cbsa"], name: "by_date_summary_id_country_cbsa", unique: true, using: :btree
    t.index ["date"], name: "index_geo_on_date", using: :btree
    t.index ["trend_data_summary_id"], name: "index_geo_on_trend_data_summary_id", using: :btree
    t.index ["updated_at"], name: "index_geo_on_updated_at", using: :btree
  end

  create_table "glacier_archives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "provider_id",             null: false
    t.string   "archive_id",  limit: 138, null: false
    t.date     "trend_date",              null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["created_at"], name: "index_glacier_archives_on_created_at", using: :btree
    t.index ["provider_id", "trend_date", "created_at"], name: "provider_id_trend_date_created_at", unique: true, using: :btree
    t.index ["provider_id"], name: "index_glacier_archives_on_provider_id", using: :btree
    t.index ["trend_date"], name: "index_glacier_archives_on_trend_date", using: :btree
  end

  create_table "import_log", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "started_at",    null: false
    t.datetime "ended_at"
    t.string   "file_name",     null: false
    t.date     "period_ending"
    t.integer  "provider_id",   null: false
    t.index ["file_name", "provider_id"], name: "by_filename_provider_id", unique: true, using: :btree
  end

  create_table "last_import", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "provider_id"
    t.string   "country_code", limit: 5
    t.date     "trend_date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["provider_id", "country_code"], name: "by_provider_id_country_code", unique: true, using: :btree
  end

  create_table "people_by_date", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "trend_date"
    t.integer  "person_id"
    t.string   "person_name"
    t.string   "email_address"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["country_code"], name: "index_people_by_date_on_country_code", using: :btree
    t.index ["person_id"], name: "index_people_by_date_on_person_id", using: :btree
    t.index ["trend_date"], name: "index_people_by_date_on_trend_date", using: :btree
  end

  create_table "people_by_month", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_month"
    t.string   "trend_month_display"
    t.integer  "person_id"
    t.string   "person_name"
    t.string   "email_address"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["country_code"], name: "index_people_by_month_on_country_code", using: :btree
    t.index ["person_id"], name: "index_people_by_month_on_person_id", using: :btree
    t.index ["trend_month"], name: "index_people_by_month_on_trend_month", using: :btree
  end

  create_table "people_by_year", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_year"
    t.integer  "person_id"
    t.string   "person_name"
    t.string   "email_address"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["country_code"], name: "index_people_by_year_on_country_code", using: :btree
    t.index ["person_id"], name: "index_people_by_year_on_person_id", using: :btree
    t.index ["trend_year"], name: "index_people_by_year_on_trend_year", using: :btree
  end

  create_table "providers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 50
  end

  create_table "trans_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 15
    t.index ["name"], name: "index_trans_types_on_name", using: :btree
  end

  create_table "trend_data_detail", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id",                                                  default: 0, null: false
    t.date     "sale_date",                                                              null: false
    t.string   "country_code",          limit: 2,                                        null: false
    t.string   "zip_code",              limit: 12,                                       null: false
    t.integer  "qty"
    t.string   "artist_name",           limit: 120
    t.integer  "artist_id"
    t.string   "album_name"
    t.integer  "album_id",                                                   default: 0, null: false
    t.string   "album_type",            limit: 20
    t.string   "song_name"
    t.integer  "song_id",                                                    default: 0, null: false
    t.string   "tunecore_isrc",         limit: 12
    t.string   "optional_isrc",         limit: 12
    t.string   "upc",                   limit: 14
    t.integer  "trans_type_id",                                                          null: false
    t.integer  "provider_id"
    t.string   "royalty_currency_id",   limit: 3
    t.decimal  "royalty_price",                     precision: 14, scale: 4
    t.decimal  "customer_price",                    precision: 14, scale: 4
    t.boolean  "is_promo"
    t.integer  "import_log_id"
    t.integer  "trend_data_summary_id",                                      default: 0, null: false
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.index ["artist_id"], name: "index_trend_data_detail_on_artist_id", using: :btree
    t.index ["artist_name"], name: "index_trend_data_detail_on_artist_name", using: :btree
    t.index ["country_code"], name: "index_trend_data_detail_on_country_code", using: :btree
    t.index ["person_id", "sale_date", "country_code", "zip_code", "album_id", "song_id", "trans_type_id", "provider_id"], name: "by_person_date_album_song_ttype_provider", unique: true, using: :btree
    t.index ["person_id"], name: "index_trend_data_detail_on_person_id", using: :btree
    t.index ["sale_date"], name: "index_trend_data_detail_on_sale_date", using: :btree
    t.index ["trans_type_id"], name: "index_trend_data_detail_on_trans_type_id", using: :btree
    t.index ["trend_data_summary_id"], name: "index_trend_data_detail_on_trend_data_summary_id", using: :btree
    t.index ["zip_code"], name: "index_trend_data_detail_on_zip_code", using: :btree
  end

  create_table "trend_data_detail_error", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.date     "sale_date"
    t.string   "country_code",          limit: 2
    t.string   "zip_code",              limit: 12
    t.integer  "qty"
    t.string   "artist_name",           limit: 120
    t.integer  "artist_id"
    t.string   "album_name"
    t.integer  "album_id"
    t.string   "album_type",            limit: 20
    t.string   "song_name"
    t.integer  "song_id"
    t.string   "tunecore_isrc",         limit: 12
    t.string   "optional_isrc",         limit: 12
    t.string   "upc",                   limit: 14
    t.integer  "trans_type_id"
    t.integer  "provider_id"
    t.integer  "provider_customer_id"
    t.string   "store_identifier",      limit: 20
    t.string   "royalty_currency_id",   limit: 3
    t.decimal  "royalty_price",                     precision: 14, scale: 4
    t.decimal  "customer_price",                    precision: 14, scale: 4
    t.boolean  "is_promo"
    t.integer  "import_log_id"
    t.integer  "trend_data_summary_id"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "trend_data_detail_two", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id",                                                  default: 0, null: false
    t.date     "sale_date",                                                              null: false
    t.string   "country_code",          limit: 2,                                        null: false
    t.string   "zip_code",              limit: 12,                                       null: false
    t.integer  "qty"
    t.string   "artist_name",           limit: 120
    t.integer  "artist_id"
    t.string   "album_name"
    t.integer  "album_id",                                                   default: 0, null: false
    t.string   "album_type",            limit: 20
    t.string   "song_name"
    t.integer  "song_id",                                                    default: 0, null: false
    t.string   "tunecore_isrc",         limit: 12
    t.string   "optional_isrc",         limit: 12
    t.string   "upc",                   limit: 14
    t.integer  "trans_type_id",                                                          null: false
    t.integer  "provider_id"
    t.string   "royalty_currency_id",   limit: 3
    t.decimal  "royalty_price",                     precision: 14, scale: 4
    t.decimal  "customer_price",                    precision: 14, scale: 4
    t.boolean  "is_promo"
    t.integer  "import_log_id"
    t.integer  "trend_data_summary_id",                                      default: 0, null: false
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.index ["artist_id"], name: "index_trend_data_detail_two_on_artist_id", using: :btree
    t.index ["artist_name"], name: "index_trend_data_detail_two_on_artist_name", using: :btree
    t.index ["country_code"], name: "index_trend_data_detail_two_on_country_code", using: :btree
    t.index ["person_id", "sale_date", "country_code", "zip_code", "album_id", "song_id", "trans_type_id", "provider_id"], name: "by_person_date_album_song_ttype_provider", unique: true, using: :btree
    t.index ["person_id"], name: "index_trend_data_detail_two_on_person_id", using: :btree
    t.index ["sale_date"], name: "index_trend_data_detail_two_on_sale_date", using: :btree
    t.index ["trans_type_id"], name: "index_trend_data_detail_two_on_trans_type_id", using: :btree
    t.index ["trend_data_summary_id"], name: "index_trend_data_detail_two_on_trend_data_summary_id", using: :btree
    t.index ["zip_code"], name: "index_trend_data_detail_two_on_zip_code", using: :btree
  end

  create_table "trend_data_summary", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date",                      null: false
    t.integer  "person_id"
    t.integer  "album_id",      default: 0, null: false
    t.integer  "song_id",       default: 0, null: false
    t.integer  "trans_type_id",             null: false
    t.integer  "qty"
    t.integer  "provider_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["album_id"], name: "index_trend_data_summary_on_album_id", using: :btree
    t.index ["created_at"], name: "index_trend_data_summary_on_created_at", using: :btree
    t.index ["date"], name: "index_trend_data_summary_on_date", using: :btree
    t.index ["person_id", "date", "album_id", "song_id", "trans_type_id", "provider_id"], name: "by_person_date_album_song_ttype_provider", unique: true, using: :btree
    t.index ["person_id", "provider_id", "date"], name: "person_id", using: :btree
    t.index ["person_id"], name: "index_trend_data_summary_on_person_id", using: :btree
    t.index ["song_id"], name: "index_trend_data_summary_on_song_id", using: :btree
    t.index ["trans_type_id"], name: "index_trend_data_summary_on_trans_type_id", using: :btree
    t.index ["updated_at"], name: "index_trend_data_summary_on_updated_at", using: :btree
  end

  create_table "zipcodes", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "zipcode",                        limit: 5,                            null: false, comment: "Five digit zip code of the area."
    t.string  "primary_record",                 limit: 1,                                         comment: "Indicates if this is a primary zipcode or not."
    t.integer "population",                                                                       comment: "Population of the zip.",                                                                                                                                                                                                            unsigned: true
    t.integer "households",                                                                       comment: "Number of households of the zipcode",                                                                                                                                                                                               unsigned: true
    t.integer "white_population",                                                                 comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "black_population",                                                                 comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "hispanic_population",                                                              comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "asian_population",                                                                 comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "hawaiian_population",                                                              comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "indian_population",                                                                comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "other_population",                                                                 comment: "Estimated population.",                                                                                                                                                                                                             unsigned: true
    t.integer "male_population",                                                                  comment: "Estimated Male population.",                                                                                                                                                                                                        unsigned: true
    t.integer "female_population",                                                                comment: "Estimated Female population.",                                                                                                                                                                                                      unsigned: true
    t.decimal "persons_per_household",                      precision: 4,  scale: 2,              comment: "Estimated average number of persons per household."
    t.integer "average_house_value",                                                              comment: "Average house value in County.",                                                                                                                                                                                                    unsigned: true
    t.integer "income_per_household",                                                             comment: "Average household income.",                                                                                                                                                                                                         unsigned: true
    t.decimal "median_age",                                 precision: 3,  scale: 1,              comment: "Median age for all people."
    t.decimal "median_age_male",                            precision: 3,  scale: 1,              comment: "Median age for male."
    t.decimal "median_age_female",                          precision: 3,  scale: 1,              comment: "Median age for female."
    t.decimal "latitude",                                   precision: 12, scale: 6,              comment: "Geo coordinate measured in degrees north or south of equator."
    t.decimal "longitude",                                  precision: 12, scale: 6,              comment: "Geo coordinate measured in degrees east or west of the greenwitch meridian"
    t.integer "elevation",                                                                        comment: "The average elevation of the County."
    t.string  "state",                          limit: 2,                                         comment: "2 letter state name abbrivation."
    t.string  "state_name",                     limit: 35,                                        comment: "The full US state name."
    t.string  "city_type",                      limit: 1,                                         comment: "Indicates type of locale such as Post Office, Stations or Branch."
    t.string  "city_alias_abbrivation",         limit: 13,                                        comment: "12 Character abbrevation for the city alias name."
    t.string  "area_code",                      limit: 55,                                        comment: "Telephone area codes available in this zip code."
    t.string  "city",                           limit: 35,                                        comment: "Name of the city as designated by the USPS."
    t.string  "city_alias_name",                limit: 35,                                        comment: "Alias name of the city if it exist."
    t.string  "county",                         limit: 45,                                        comment: "Name of County or Parish this zip code resides in."
    t.string  "county_fips",                    limit: 5,                                         comment: "FIPS code for the County this zip code resides in."
    t.string  "state_fips",                     limit: 2,                                         comment: "FIPS code for the State this zip code resides in."
    t.string  "time_zone",                      limit: 2,                                         comment: "Hours past Greenwich Time Zone this ZIP code belongs to."
    t.string  "daylight_savings",               limit: 1,                                         comment: "Flag indicating whether this ZIP Code observes daylight savings."
    t.string  "msa",                            limit: 35,                                        comment: "Metropolitan Statistical Area number assigned by Census 2000."
    t.string  "pmsa",                           limit: 4,                                         comment: "Primary Metropolitan Statistical Area Number."
    t.string  "csa",                            limit: 3,                                         comment: "Core Statistical Area. This area is a group of MSA's combined into a population core area."
    t.string  "cbsa",                           limit: 5,                                         comment: "Core Based Statistical Area Number."
    t.string  "cbsa_div",                       limit: 5,                                         comment: "Core Based Statistical Area Division."
    t.string  "cbsa_type",                      limit: 5,                                         comment: "Core Based Statistical Area Type (Metro or Micro)."
    t.string  "cbsa_name",                      limit: 150,                                       comment: "Core Based Statistical Area Name or Title."
    t.string  "msa_name",                       limit: 150,                                       comment: "Primary Metropolitan Statistical Area name or Title."
    t.string  "pmsa_name",                      limit: 150,                                       comment: "Primary Metropolitan Statistical Area name or Title."
    t.string  "region",                         limit: 10,                                        comment: "A geographic area consisting of several States defined by the U.S. Department of Commerce, Bureau of the Census. The States are grouped into four regions and nine divisions."
    t.string  "division",                       limit: 20,                                        comment: "A geographic area consisting of several States defined by the U.S. Department of Commerce, Bureau of the Census. The States are grouped into four regions and nine divisions."
    t.string  "mailing_name",                   limit: 1,                                         comment: "Yes or No (Y/N) flag indicating whether or not the USPS accepts this City Alias Name for mailing purposes."
    t.integer "number_of_businesses",                                                             comment: "The total number of Business Establishments for this ZIP Code. Data taken from Census for 2006 Business Patterns."
    t.integer "number_of_employees",                                                              comment: "The total number of employees for this ZIP Code. Data taken from Census for 2006 Business Patterns."
    t.integer "business_first_quarter_payroll",                                                   comment: "The total payroll for the frist quarter this ZIP Code in $1000. Data taken from Census for 2006 Business Patterns."
    t.integer "business_annual_payroll",                                                          comment: "The total annual payroll for this ZIP Code in $1000. Data taken from Census for 2006 Business Patterns."
    t.string  "business_employment_flag",       limit: 1,                                         comment: "Due to confidentiality, some areas do not have actual figures for employment information. Employment and payroll data are replaced by zeroes with the Employment Flag denoting employment size class."
    t.integer "growth_rank",                                                                      comment: "The rank in which this county is growing according to the US Census."
    t.integer "growth_housing_units_2003",                                                        comment: "The estimated number of housing units in this county as of July 1, 2003."
    t.integer "growth_housing_units_2004",                                                        comment: "The estimated number of housing units in this county as of July 1, 2004. Source: Housing Unit Estimates for the 100 Fastest Growing U.S. Counties between July 1, 2003 and July 1, 2004. Population Division, U.S. Census Bureau."
    t.integer "growth_increase_number",                                                           comment: "The change in housing units from 2003 to 2004, expressed as a number."
    t.decimal "growth_increase_percentage",                 precision: 3,  scale: 1,              comment: "The change in housing units from 2003 to 2004, expressed as a percentage."
    t.integer "cbsa_pop_2003",                                                                    comment: "The estimated population for the selected CBSA in 2003."
    t.integer "cbsa_div_pop_2003",                                                                comment: "The estimated population for the selected CBSA Division in 2003."
    t.string  "congressional_district",         limit: 150,                                       comment: "This field shows which Congressional Districts the ZIP Code belongs to. Currently set for 111th Congress."
    t.string  "congressional_land_area",        limit: 150,                                       comment: "This field provides the approximate land area covered by the Congressional District for which the ZIP Code belongs to."
    t.integer "delivery_residential",                                                             comment: "The number of active residential delivery mailboxes and centralized units for this ZIP Code. This excludes PO Boxes and all other contract box types."
    t.integer "delivery_business",                                                                comment: "The number of active business delivery mailboxes and centralized units for this ZIP Code. This excludes PO Boxes and all other contract box types."
    t.integer "delivery_total",                                                                   comment: "The total number of delivery receptacles for this ZIP Code. This includes curb side mailboxes, centralized units, PO Boxes, NDCBU, and contract boxes."
    t.string  "preferred_last_line_key",        limit: 10,                                        comment: "Links this record with other products ZIP-Codes.com offers."
    t.string  "classification_code",            limit: 1,                                         comment: "The classification type of this ZIP Code."
    t.string  "multi_county",                   limit: 1,                                         comment: "Flag indicating whether this ZIP Code crosses county lines."
    t.string  "csa_name",                                                                         comment: "The name of the CSA this ZIP Code is in."
    t.string  "csa_div_name",                                                                     comment: "The name of the CBSA Division this ZIP Code is in."
    t.string  "city_state_key",                 limit: 6,                                         comment: "Links this record with other products ZIP-Codes.com offers such as the ZIP+4."
    t.integer "population_estimate",                                                              comment: "An up to the month population estimate for this ZIP Code."
    t.decimal "land_area",                                  precision: 12, scale: 6,              comment: "The land area of this ZIP Code in Square Miles."
    t.decimal "water_area",                                 precision: 12, scale: 6,              comment: "The water area of this ZIP Code in Square Miles."
    t.string  "city_alias_code",                limit: 5,                                         comment: "Code indication the type of the city alias name for this record. Record can be Abbreviations, Universities, Government, and more."
    t.string  "city_mixed_case",                limit: 35,                                        comment: "The city name in mixed case (i.e. Not in all uppercase letters)."
    t.string  "city_alias_mixed_case",          limit: 35,                                        comment: "The city alias name in mixed case (i.e. Not in all uppercase letters)."
    t.integer "box_count",                                                                        comment: "Total count of PO Box deliveries in this ZIP Code "
    t.integer "sfdu",                                                                             comment: "Total count of single family deliveries in this ZIP Code; generally analogous to homes"
    t.integer "mfdu",                                                                             comment: "Total count of multifamily deliveries in this ZIP Code; generally analogous to apartments"
    t.string  "cbsa_short_name",                limit: 60
    t.index ["cbsa"], name: "index_zipcodes_on_cbsa", using: :btree
    t.index ["state", "city"], name: "state_city", using: :btree
    t.index ["zipcode", "primary_record"], name: "zipcode", using: :btree
  end

end
