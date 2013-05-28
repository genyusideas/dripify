set :stage, 'production'
set :rails_env, 'production'
set :app_env, 'production'
set :branch, 'master'
set :keep_releases, 10

set :rake, "bundle exec rake"

after 'db:create', 'db:migrate'
