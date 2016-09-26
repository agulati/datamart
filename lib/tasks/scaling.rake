namespace :scaling do
  task shutdown_workers: :environment do
    Resque.workers.select { |worker| worker.id.split(":").first == ENV["INSTANCE"] }.each { |worker| `kill -3 #{worker.pid}` }
  end
end
