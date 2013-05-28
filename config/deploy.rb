require 'rvm/capistrano'
require 'bundler/capistrano'
load 'deploy/assets'

set :stage_dir, "config/deploy/stages"
set :stages, Dir[ "#{File.dirname(__FILE__)}/deploy/stages/*.rb" ].collect { |fn| File.basename(fn, ".rb") }
set :default_stage, "production"

set :application, "Dripify"
set :scm, :git
set :user, "ubuntu"
set :repository,  "git@github.com:genyusideas/dripify.git"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :copy


set :use_sudo, true

set :scm_username, "jmataya"
default_run_options[:pty] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "drippio-prod.pem")]

# Enable Agent Forwarding
ssh_options[:forward_agent] = true

namespace :db do
  ['db:drop', 'db:create', 'db:reset', 'db:migrate', 'db:seed'].each do |task|
    _task = task.split(':')[1] || task
    task _task.to_sym, roles: :db do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} #{rake} #{task} --trace"
    end
  end
end

namespace :deploy do
  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
end
