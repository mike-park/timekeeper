# Minimal Heroku unicorn config
# Heroku has a 30s timeout so we enforce the same
# Depending on memory usage workers can be bumped to 3-4
# preload_app=true can cause issues if you don't reconnect things correctly
worker_processes 3
timeout 30
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
end
