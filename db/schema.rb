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

ActiveRecord::Schema.define(version: 20161014161357) do

  create_table "aggregation_exclusions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "exclusion_id"
    t.string   "exclusion_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

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
    t.index ["album_id", "album_name", "album_type"], name: "daily_album", using: :btree
    t.index ["trend_date", "album_id", "album_name", "album_type"], name: "date_and_album", using: :btree
    t.index ["trend_date", "trend_month", "artist_name", "country_code", "country_name"], name: "artists_by_date", using: :btree
    t.index ["trend_date", "trend_month", "person_id", "person_name", "email_address", "country_code", "country_name"], name: "people_by_date", using: :btree
    t.index ["trend_date"], name: "index_albums_by_date_on_trend_date", using: :btree
    t.index ["trend_month", "album_id", "album_name", "album_type", "country_code", "country_name"], name: "month_album_country", using: :btree
  end

  create_table "albums_by_month", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_month"
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
    t.index ["album_id", "album_name", "album_type"], name: "monthly_album", using: :btree
    t.index ["trend_month", "album_id", "album_name", "album_type"], name: "month_and_album", using: :btree
    t.index ["trend_month"], name: "index_albums_by_month_on_trend_month", using: :btree
    t.index ["trend_year", "album_id", "album_name", "album_type", "country_code", "country_name"], name: "albums_by_year", using: :btree
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
    t.index ["album_id", "album_name", "album_type"], name: "yearly_album", using: :btree
    t.index ["trend_year"], name: "index_albums_by_year_on_trend_year", using: :btree
  end

  create_table "artists_by_date", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "trend_date"
    t.integer  "trend_month"
    t.integer  "trend_year"
    t.string   "artist_name"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["artist_name"], name: "daily_artist", using: :btree
    t.index ["trend_date", "artist_name"], name: "date_and_artist", using: :btree
    t.index ["trend_date"], name: "index_artists_by_date_on_trend_date", using: :btree
    t.index ["trend_month", "artist_name", "country_code", "country_name"], name: "artists_by_month", using: :btree
  end

  create_table "artists_by_month", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_month"
    t.integer  "trend_year"
    t.string   "artist_name"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "stream_count"
    t.integer  "album_download_count"
    t.integer  "song_download_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["artist_name"], name: "monthly_artist", using: :btree
    t.index ["trend_month", "artist_name"], name: "month_and_artist", using: :btree
    t.index ["trend_month"], name: "index_artists_by_month_on_trend_month", using: :btree
    t.index ["trend_year", "artist_name", "country_code", "country_name"], name: "artists_by_year", using: :btree
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
    t.index ["artist_name"], name: "yearly_artist", using: :btree
    t.index ["trend_year"], name: "index_artists_by_year_on_trend_year", using: :btree
  end

  create_table "people_by_date", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "trend_date"
    t.integer  "trend_month"
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
    t.index ["person_id", "person_name", "email_address"], name: "daily_person", using: :btree
    t.index ["trend_date", "person_id", "person_name", "email_address"], name: "date_and_person", using: :btree
    t.index ["trend_date"], name: "index_people_by_date_on_trend_date", using: :btree
    t.index ["trend_month", "person_id", "person_name", "email_address", "country_code", "country_name"], name: "people_by_month", using: :btree
  end

  create_table "people_by_month", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "trend_month"
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
    t.index ["person_id", "person_name", "email_address"], name: "monthly_person", using: :btree
    t.index ["trend_month", "person_id", "person_name", "email_address"], name: "month_and_person", using: :btree
    t.index ["trend_month"], name: "index_people_by_month_on_trend_month", using: :btree
    t.index ["trend_year", "person_id", "person_name", "email_address", "country_code", "country_name"], name: "people_by_year", using: :btree
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
    t.index ["person_id", "person_name", "email_address"], name: "yearly_person", using: :btree
    t.index ["trend_year"], name: "index_people_by_year_on_trend_year", using: :btree
  end

end
