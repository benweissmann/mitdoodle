# MITDoodle

A Doodle clone that uses MIT Certificates for authentication


## Setup

1. create `config/database.yml`. You can copy `config/database.example.yml`, which is a sample configuration that uses SQLite.
2. copy `config/google.example.yml` to `config/google.yml` and put in your api key
3. edit `MITDOODLE_HOME` in `config/initializers/paths.rb` to point to your host and `MITDOODLE_PERMALINK_HOME` to point to where URL shortener links should point to (this can be the same as `MITDOODLE_HOME`)
4. standard Rails procedure to set up and start (`bundle install` to install gems; `rake db:create` to create database; `rake db:schema:load` to load schema; `rails s` to run server)

## Contributing

Fork the repo on GitHub, make your changes, and submit a pull request.