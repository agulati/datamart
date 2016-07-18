web: bundle exec rails server -p $PORT
worker1: QUEUE=* bundle exec rake environment resque:work
worker2: QUEUE=* bundle exec rake environment resque:work
scheduler: rake environment resque:scheduler
