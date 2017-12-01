set :rake_env, :production
set :rails_env, :production
set :puma_env, :production

server '******',
        user: 'deploy',
        roles: %w{app web db}

set :branch, :master