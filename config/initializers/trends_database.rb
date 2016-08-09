TRENDS_DB = YAML.load_file(File.join(Rails.root, "config", "trends_database.yml"))[Rails.env.to_s]
