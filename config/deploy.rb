require 'bundler/capistrano'

set :application, "cMoM"

set :scm, 'git'
set :repository,  "."
set :git_enable_submodules, 1

set :deploy_to,  "/var/www/#{application}"
set :deploy_via, :copy

set :location, "solots.com"
role :app, location
role :web, location
role :db,  location, :primary => true

set :user, "app"
set :use_sudo, false

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "app_rsa")]

after 'deploy:update_code', 'deploy:synmlink_broker'

namespace :deploy do

  desc "Symbolic link the broker.yml to protected broker.yml"
  task :symlink_broker, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/broker.yml #{release_path}/config/broker.yml"
  end

  task :start, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

