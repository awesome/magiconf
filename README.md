Magiconf
========
Magiconf is a light-weight alternative to figaro that is designed to work directly with Rails. Easily store and access all your application's configuration data using a single yaml file. A great solution for storing passwords, dealing with heroku, and working in a team with different development environments.

Installation
------------
1. Add `magiconf` to your application's Gemfile:

        gem 'magiconf'

  Don't forget to run the `bundle` command to install.

2. Next, create `config/application.yml`:

        touch config/application.yml

3. Add your configuration variables:

    ```yaml
    # config/application.yml
    username: 'seth'
    password: 'aj29slda'
    development:
      pusher_url: 'http://github.com/pusher'
    production:
      pusher_url: 'http://google.com/pusher'
    ```

Usage
-----
You now have access to all your configuration data in an easy constant: `YourApp::Config`. For example, if my Rails app was name `Envelope`, I could access my configuration with `Envelope::Config`. Let's look at a simple example:

```ruby
# Gemfile
gem 'magiconf'
gem 'rails'
```

```yaml
# config/application.yml
username: 'seth'
development:
  password: 'test'
production:
  password: 'super_secret_test'
```

```ruby
# app/controllers/application_controller.rb
def authenticate
  username = Envelope::Config.username
  password = Envelope::Config.password

  render :unathorized unless params[:username] == username && params[:password] == password
end
```
**Note: Magiconf will automatically merge the keys associated with your current Rails environment with the top-level ones.**

Nested Keys
-----------
Sometimes, it might make sense to nest your data. For example, a common pusher configuration might look like this:

```yaml
# config/application.yml
pusher:
  app_id: 123
  key: abcdef
  secret: abcdefghijklmnop1234567890
```

The `.pusher` method would return this data, accessible in a hash:

```ruby
>> Envelope::Config.pusher
=> {"app_id"=>123, "key"=>"abcdef", "secret"=>"abcdefghijklmnop1234567890"}
```

**Notice that the keys are strings, not symbols.** This means you would do something like this in an initializer:

```ruby
# config/initializers/pusher.rb
Pusher.app_id = Envelope::Config.pusher['app_id']  # not :app_id
Pusher.key = Envelope::Config.pusher['key']        # not :key
Pusher.secret = Envelope::Config.pusher['secret']  # not :secret
```

Using in Application Configuration
----------------------------------
Imagine you want to define application configuration variables with Magiconf - maybe you want to define the default host for mail in development. You'd do something like this:

```yaml
# config/application.yml
development:
  host: 'www.example.com'
```

```ruby
# config/environments/development.rb
...
config.action_mailer.default_url_options = { host: Envelope::Config.host }
```

...And if you try to start up your server, you'll see:

```text
uninitialized constant MyApp::Config (NameError)
```

Huh? Well, it turns out that, even though Magiconf hooks into the Rails initialization process as early as possible, it's not soon enough. There's no way for me to get added anywhere earlier in the stack. Fortunately, there's an easy workaround.

Open up `config/application.rb` and add the following line to the bottom of the file (around line 72):

```ruby
# config/application.rb
...
Magiconf.setup!
```

Restart your server and things will work like a charm!

Using with Environment Variables
----------------------------------

magiconf parses the YAML as ERB, allowing you to set the application configuration using environment variables like:

```
development:
  my_secret: <%= ENV['MY_SECRET'] %>
```

If you are hosting your application on Heroku, you are able to set your environment variables through the CLI and use them in your application with magiconf.

If you want to use environment variables while also having defaults, you can:

```
development:
  my_secret: <%= ENV['MY_SECRET'] || 'ABCD1234' %>
```

This allows you to use a `.env` file and a `Procfile` from [Foreman](https://github.com/ddollar/foreman) to manage your secret keys.


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
