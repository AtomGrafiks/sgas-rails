# Sgas::Rails
Sgas::Rails is an plugin based on middleware to allow or deny request with a SAGS Server. 


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sgas-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sgas-rails
```

## Usage
SGAS Plugin for Rails need a Simple Go Auth Server to work.

First step, create an initializer to config the middleware
```ruby
Sgas::Middleware.configure do |config|
  # Configure base URI of SGAS service
  config.base_uri   = 'http://localhost:8081/'

  # Target of redirect when user not logged or when her token is expired.
  # path must be an absolute or relative path
  config.login_path = '/login'
end
```
Second step, you need to set the middleware, SGAS adapter need `ActionDispatch::Cookies` to store jwtToken on cookies.
```ruby
  config.middleware.use ActionDispatch::Cookies
  config.middleware.use Sgas::Middleware::Protection
```
**WARNING**: On Multi-tennancy configuration with apartment gem, you need to insert SGAS after elevator
```ruby
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use Apartment::Elevators::Domain
    config.middleware.insert_after Apartment::Elevators::Domain, Sgas::Middleware::Protection

```


When configuration is done, you can authenticate your routes with `auth` opts on `config/routes.rb`
```ruby
  # auth a ressources
  resources :books, auth: true

  # auth a scope
  scope :admin, auth: true do
    resources :users
  end

  # auth a lambda route
  get :home, to: 'application#home', auth: true
```
## Custom protection
You need to custom protection middleware ? You can !

Create a new class on your favorite lib folder (`/lib/` is good)
```ruby
class OwnProxy < Sgas::Middleware::Proxy

  # Use session_check method to surclass checker
  def session_check
    return nil unless token

    Faraday.new(url: ENV['PROXY_AUTH_HOST']).post do |req|
      req.url '/auth'
      req.headers['Content-Type'] = 'application/json'
      # Add custom headers for multi-tennancy configuration for example
      req.headers['Tenant'] = Apartment::Tenant.current.gsub('development_', '')
      
      # Send token
      # **WARNING** the body can't be changed !
      # The format { auth_token: token } is required
      req.body = { auth_token: token }.to_json
    end
  end
end
```

After the creation of your awesome proxy ! you need to Add to configuration file `config/initializers/sgas.rb`
```
config.proxy = 'Sgas::Middleware::OwnProxy'
```
and require your proxy on `config/application.rb`
```ruby 
require 'sgas/middleware'
require './lib/own_proxy.rb'

module MyRailsApp
  ...
```