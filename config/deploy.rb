require 'rvm/capistrano'
require 'bundler/capistrano'
load 'deploy/assets'

set :application, "Dripify"
set :repository,  "git@github.com:genyusideas/dripify.git"

set :scm, :git

set :deploy_to, "~/DripifyApi"

role :web, "54.215.0.45"                          
role :app, "54.215.0.45"                          
role :db,  "54.215.0.45", :primary => true

set :user, "ubuntu"
set :scm_username, "jmataya"
default_run_options[:pty] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "drippio-prod.pem")]

# Enable Agent Forwarding
ssh_options[:forward_agent] = true

# Use the master branch
set :branch, "master"

# Use remote caching
# set :deploy_via, :remote_cache
