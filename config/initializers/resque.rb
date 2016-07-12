Resque.logger = Logger.new(Rails.root.join('log', "resque_#{Rails.env}.log"))
Resque.redis.namespace = "resque:tc-trends"
