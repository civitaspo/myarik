# Myarik

Myarik is a codenize-tool for Redash.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'myarik'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myarik

## Usage

1. Go to your profile page (`<your redash url>/users/me`).
1. Get your api key.
1. Export your api key as `MYARIK_REDASH_API_KEY`.
   ```
   export MYARIK_REDASH_API_KEY=YOUR_REDASH_API_KEY
   ```
1. Prepare resource definitions.
   ```
   data_source 'redash-db' do
     name 'redash-db'
     type 'pg'
     options do
       host 'postgres'
       user 'postgres'
       dbname 'postgres'
     end
   end

   ```
1. Run myarik
   ```
   myarik apply path/to/resource_definition.rb --redash-url <your redash url>
   ```

## Codenizable Resources
### `data_source`
* **name**: DataSource name (string, required)
* **type**: DataSource type (string, required)
* **options**: DataSource options (map, optional)
    * Configuable options depends on **type**.
        * You can see the options by `<your redash url>/api/data_sources/types`.
        * Secret options are not configuable, because Redash api does not return the value.


## Development

1. Setup local Redash.
   ```
   docker-compose up
   ```
1. Go to your profile page (`<your redash url>/users/me`).
1. Get your api key.
1. Export your api key as `MYARIK_REDASH_API_KEY`.
   ```
   export MYARIK_REDASH_API_KEY=YOUR_REDASH_API_KEY
   ```
1. Run examples
   ```
    myarik apply example/Redashfile --redash-url http://localhost:5000 
   ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/civitaspo/myarik. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Myarik project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/myarik/blob/master/CODE_OF_CONDUCT.md).
