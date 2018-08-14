# React Demo API

## Development Setup

1. Clone the repo from Github:

        $ git clone https://github.com/reactTestDemo/react-demo-api.git

2. Ensure you have the correct ruby version via rbenv or RVM as defined in .ruby-version

3. Bundle the gems:

        $ gem install bundler
        $ bundle install

4. Create migration and run seed.rb file

        $ bundle exec rake db:create
        $ bundle exec rake db:migrate
        $ bundle exec rake db:seed

5. Application must be run `port 3010`
        $ bundle exec rails s -p 3010

## Admin User: must need to execute rake db:seed
      email: admin@react.com
      password: password