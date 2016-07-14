Resque.redis.namespace  = "resque:tc-trends"
Resque.schedule         = YAML.load_file(Rails.root.join("config", "schedule.yml"))
