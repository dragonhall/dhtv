# DragonHall+ TV

[![Codeship Status for dragonhall/dhtv](https://app.codeship.com/projects/92bcbe20-5fa0-0138-b578-626fa30a50f4/status?branch=master)](https://app.codeship.com/projects/392446)


## Deployment

This project is automagically built and deployed by [CodeShip](https://app.codeship.com/projects/392446)

## Development

After checkout, you should setup your development environment for this application:

```console
$ rvm use --install --create $(cat .ruby-version)@$(cat .ruby-gemset)
$ bundle install
$ cp config/database.yml.sample config/database.yml
$ cp config/redis
$ vim config/database.yml ## Edit database settings
$ bundle exec guard -i 
```

After the application is up and running, point your browser to https://dhtv.lvh.me:3001/

Tests are covered by `rubocop` and `rspec`. Run the corresponding Rake tasks. Do **not** run the tools
directly as some minor tweaks could be made inside the Rake tasks that are may or may not configured 
in the tool itself.

 
 ## Known bugs & problems

 **Important:** This project is currently highly depends on [Showtime](https://github.com/dragonhall/showtime),
 as it uses exactly same database and same tables. It means the project itself does not come with database migrations.
 For getting a working database structure you could either checkout and setup Showtime or you could fetch the latest
 db backup of the _staging_ Showtime environment and import it locally.


## TODO

 - More unit tests
 - More interface tests (Cucumber)
 - Break direct dependency from Showtime