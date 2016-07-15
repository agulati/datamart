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
    add_index :albums_by_date, :trend_month
    add_index :albums_by_date, :country_code
    add_index :albums_by_date, :album_id
    add_index :albums_by_date, :person_id
    add_index :albums_by_date, :artist_name

    create_table  :albums_by_month, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_month
      t.string    :trend_month_display
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
    add_index :albums_by_date,  :trend_year
    add_index :albums_by_month, :country_code
    add_index :albums_by_month, :album_id

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
    add_index :albums_by_year, :country_code
    add_index :albums_by_year, :album_id

    create_table  :people_by_date, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.date      :trend_date
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
    add_index :people_by_date, :country_code
    add_index :people_by_date, :person_id

    create_table  :people_by_month, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_month
      t.string    :trend_month_display
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
    add_index :people_by_month, :country_code
    add_index :people_by_month, :person_id

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
    add_index :people_by_year, :country_code
    add_index :people_by_year, :person_id

    create_table  :artists_by_date, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.date      :trend_date
      t.string    :artist_name
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :artists_by_date, :trend_date
    add_index :artists_by_date, :country_code
    add_index :artists_by_date, :artist_name

    create_table  :artists_by_month, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer   :trend_month
      t.string    :trend_month_display
      t.string    :artist_name
      t.string    :country_code
      t.string    :country_name
      t.integer   :stream_count
      t.integer   :album_download_count
      t.integer   :song_download_count
      t.timestamps
    end

    add_index :artists_by_month, :trend_month
    add_index :artists_by_month, :country_code
    add_index :artists_by_month, :artist_name

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
    add_index :artists_by_year, :country_code
    add_index :artists_by_year, :artist_name
  end

  def down
    drop_table  :last_aggregation
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
