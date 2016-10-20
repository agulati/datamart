Resque.redis            = $redis
Resque.redis.namespace  = "resque:tc-trends:dev"
Resque.schedule         = YAML.load_file(Rails.root.join("config", "schedule.yml"))

Resque::Tabber.add_tab("Home", "/")
