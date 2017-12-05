# Rails project demo
Live Demo [click](https://still-spire-31514.herokuapp.com/)

## Run local
Copy the database setting file and version control file
```bash
cp config/database.yml.sample config/database.yml
cp .versions.conf.sample .versions.conf
cp .env.sample .env
cp config/cable.yml.sample config/cable.yml
cp config/sidekiq.yml.sample config/sidekiq.yml
```

Make sure these libs have before run
```bash
ruby -v    #2.3.0
rails -v   #5.0.0.beta3
redis-server -v  # ~> 3.0.0
elasticsearch --version #~> 2.0.0
```

Database initialization
```bash
bin/rails db:environment:set RAILS_ENV=development
rails db:drop
rails db:create db:migrate
```

Seed setup && Start server && start redis && elasticsearch
```bash
foreman start
rails db:seed
rake environment elasticsearch:import:model CLASS='Doctor' FORCE='y'
rake environment elasticsearch:import:model CLASS='Pharmacy' FORCE='y'
rails s
```

## Tests (Backend)

Setup test database

```bash
rails db:migrate RAILS_ENV=test
```

Run tests

```bash
# Run all tests
./bin/rspec

# Run one file
./bin/rspec lib/gems/appointment_queue/spec

# Skip tests with tag slow
./bin/rspec --tag ~slow

# Skip tests with tag slow: 'stripe'
./bin/rspec --tag ~slow:stripe

# Only run slow tests, useful to test stripe APIs
./bin/rspec --tag slow:stripe
```

## Tests (frontend)

We use **mocha** and **mocha-webpack** for frontend tests. Currently all tests are executed under Node.js but not browser, so you can't add tests to React components (needs DOM). For assertion library we use **chai** and **chai-as-promised**. Check their documentation for how to use.

Run tests:

```bash
# Make sure you're under the "client" directory
cd client

# Run all tests
npm run test

# Run a single test
npm run test -- test/api/middleware.test.js

# Run tests based on glob, not that the "" is needed when using *
npm run test -- "test/api/*.test.js"
# Or you can use \
npm run test -- test/api/\*.test.js
```

The test file follows the naming convension of app file except:

- They're under `test` directory instead of `app` directory.
- They're suffixed with `.test.js`

For example:

```bash
app/api/middleware.js
test/api/middleware.test.js
```

The `npm run test` will look for all `*.test.js` under test directory. That's the reason for this naming convension.


## Deploy

Cap staging
```bash
cap staging deploy
```

Cap prodcution

```bash
cap production deploy
```

## Guideline

### Git commit

Use part of [AngularJS commit
guideline](https://github.com/angular/angular.js/blob/master/CONTRIBUTING.md#commit).
Generally speaking, a commit has a **type** which must be one of the
following:

Commit starts with lowercase.

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
  (white-space, formatting, missing semi-colons, etc)
- **refactor**: A code change that neither fixes a bug or adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests
- **chore**: Changes to the build process or auxiliary tools and
  libraries such as documentation generation

A git commit example

```
feat: auth with JWT

- add gem JWT
- add service LoginUser
```

### Ruby

Follow [this one](https://github.com/bbatsov/ruby-style-guide)
Upgrade [active_model_serializers](https://github.com/rails-api/active_model_serializers/blob/master/docs/README.md)
