set :rake_env, :staging
set :rails_env, :staging
set :puma_env, :staging

server '52.64.244.218',
        user: 'deploy',
        roles: %w{app web db}

set :branch, :master
