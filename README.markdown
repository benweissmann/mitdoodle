# MITDoodle

A Doodle clone that uses MIT Certificates for authentication


## Setup

1) create `config/database.yml`
2) copy `config/google.example.yml` to `config/google.yml` and put in your api key
3) edit `MITDOODLE_HOME` in `config/initializers/paths.rb` to point to your host
4) standard Rails procedure (`bundle install; rake db:schema:load; rails s`)

## Contributing

Fork the repo on GitHub, make your changes, and submit a pull request.