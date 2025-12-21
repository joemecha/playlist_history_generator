# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

# Puma can serve each request in a thread from an internal thread pool.
# Keep this low for free tiers of Render and Supabase
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = 5
threads min_threads_count, max_threads_count

rails_env = ENV.fetch("RAILS_ENV") { "production" }

port ENV.fetch("PORT") { 3000 }

if Rails.env.production?
  workers ENV.fetch("WEB_CONCURRENCY", 1)
else
  workers 0
end


preload_app!

worker_timeout 60 if rails_env == "development"

# Specifies the `environment` that Puma will run in.
environment rails_env

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart
