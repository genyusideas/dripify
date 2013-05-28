role :web, "54.215.0.45"                          
role :app, "54.215.0.45"                          
role :db,  "54.215.0.45", :primary => true

set :stage, 'production'
set :rails_env, 'production'
set :app_env, 'production'
set :branch, 'master'
set :keep_releases, 10

set :rake, "bundle exec rake"

after 'db:create', 'db:migrate'
