class CreateAggregateTables < ActiveRecord::Migration[5.0]
  def up
    create_table  :aggregation_log, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.date      :trend_date
      t.string    :aggregation_type
      t.string    :status
      t.timestamps
    end

    create_table  :albums_by_date, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.date      :trend_date
      t.integer   :trend_month
      t.integer   :trend_year
      t.integer   :album_id
      t.string    :album_name
      t.string    :album_type
      t.string    :artist_name
      t.integer   :person_id
      t.string    :person_name
      t.string    :email_address
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :albums_by_date, :trend_date
    add_index :albums_by_date, [:trend_date, :album_id, :album_name, :album_type], name: "date_and_album"
    add_index :albums_by_date, [:album_id, :album_name, :album_type], name: "daily_album"
    add_index :albums_by_date, [:trend_month, :album_id, :album_name, :album_type, :country_code, :country_name], name: "month_album_country"
    add_index :albums_by_date, [:trend_date, :trend_month, :person_id, :person_name, :email_address, :country_code, :country_name], name: "people_by_date"
    add_index :albums_by_date, [:trend_date, :trend_month, :artist_name, :country_code, :country_name], name: "artists_by_date"

    create_table  :albums_by_month, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_month
      t.integer   :trend_year
      t.integer   :album_id
      t.string    :album_name
      t.string    :album_type
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :albums_by_month, :trend_month
    add_index :albums_by_month, [:trend_month, :album_id, :album_name, :album_type], name: "month_and_album"
    add_index :albums_by_month, [:trend_year, :album_id, :album_name, :album_type, :country_code, :country_name], name: "albums_by_year"
    add_index :albums_by_month, [:album_id, :album_name, :album_type], name: "monthly_album"

    create_table  :albums_by_year, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_year
      t.integer   :album_id
      t.string    :album_name
      t.string    :album_type
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :albums_by_year, :trend_year
    add_index :albums_by_year, [:album_id, :album_name, :album_type], name: "yearly_album"

    create_table  :people_by_date, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.date      :trend_date
      t.integer   :trend_month
      t.integer   :trend_year
      t.integer   :person_id
      t.string    :person_name
      t.string    :email_address
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :people_by_date, :trend_date
    add_index :people_by_date, [:trend_date, :person_id, :person_name, :email_address], name: "date_and_person"
    add_index :people_by_date, [:person_id, :person_name, :email_address], name: "daily_person"
    add_index :people_by_date, [:trend_month, :person_id, :person_name, :email_address, :country_code, :country_name], name: "people_by_month"

    create_table  :people_by_month, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_month
      t.integer   :trend_year
      t.integer   :person_id
      t.string    :person_name
      t.string    :email_address
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :people_by_month, :trend_month
    add_index :people_by_month, [:trend_month, :person_id, :person_name, :email_address], name: "month_and_person"
    add_index :people_by_month, [:trend_year, :person_id, :person_name, :email_address, :country_code, :country_name], name: "people_by_year"
    add_index :people_by_month, [:person_id, :person_name, :email_address], name: "monthly_person"

    create_table  :people_by_year, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_year
      t.integer   :person_id
      t.string    :person_name
      t.string    :email_address
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :people_by_year, :trend_year
    add_index :people_by_year, [:person_id, :person_name, :email_address], name: "yearly_person"

    create_table  :artists_by_date, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.date      :trend_date
      t.integer   :trend_month
      t.integer   :trend_year
      t.string    :artist_name
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :artists_by_date, :trend_date
    add_index :artists_by_date, [:trend_date, :artist_name], name: "date_and_artist"
    add_index :artists_by_date, :artist_name, name: "daily_artist"
    add_index :artists_by_date, [:trend_month, :artist_name, :country_code, :country_name], name: "artists_by_month"

    create_table  :artists_by_month, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_month
      t.integer   :trend_year
      t.string    :artist_name
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :artists_by_month, :trend_month
    add_index :artists_by_month, [:trend_month, :artist_name], name: "month_and_artist"
    add_index :artists_by_month, [:trend_year, :artist_name, :country_code, :country_name], name: "artists_by_year"
    add_index :artists_by_month, :artist_name, name: "monthly_artist"

    create_table  :artists_by_year, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_year
      t.string    :artist_name
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :artists_by_year, :trend_year
    add_index :artists_by_year, :artist_name, name: "yearly_artist"
  end

  def down
    drop_table  :aggregation_log
    drop_table  :albums_by_date
    drop_table  :albums_by_month
    drop_table  :albums_by_year
    drop_table  :people_by_date
    drop_table  :people_by_month
    drop_table  :people_by_year
    drop_table  :artists_by_date
    drop_table  :artists_by_month
    drop_table  :artists_by_year
  end
end
