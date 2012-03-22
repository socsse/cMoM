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

after "deploy:update_code", "deploy:symlink_config_files"
#, "deploy:precompile_assets"

namespace :deploy do

  desc "Create shared directories"
  task :create_shared_directories, :roles => :app do
    run "mkdir -p #{deploy_to}/shared/config"
    run "mkdir -p #{deploy_to}/shared/log"
    run "mkdir -p #{deploy_to}/shared/tmp"
  end

  desc "Symbolicly link generated config files"
  task :symlink_config_files, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/aws.yml #{release_path}/config/aws.yml"
    run "ln -nfs #{deploy_to}/shared/config/broker.yml #{release_path}/config/broker.yml"
  end

#  desc "Precompile assets for production"
#  task :precompile_assets, :roles => :app do
#    run "cd #{current_path}; rm -rf public/assets/*"
#    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
#  end

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

load    'deploy/assets'

