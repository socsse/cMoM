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

namespace :deploy do

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

set :user, "app"
set :use_sudo, false

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "app_rsa")]
