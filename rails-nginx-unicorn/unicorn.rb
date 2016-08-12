app_dir = "/app"
 
working_directory app_dir
 
pid "#{app_dir}/tmp/unicorn.pid"
 
stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"
 
worker_processes (ENV["UNICORN_WOKRER"] || 4).to_i
listen "/tmp/unicorn.sock", :backlog => 64
timeout 30

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['DB_POOL'] || 5
    ActiveRecord::Base.establish_connection(config)
  end 
end
