# ExOauth2Provider

[![Build Status](https://travis-ci.org/danschultzer/ex_oauth2_provider.svg?branch=master)](https://travis-ci.org/danschultzer/ex_oauth2_provider)

The no brainer library to add OAuth 2 provider functionality to your elixir or phoenix app.

## Installation

Add ExOauth2Provider to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # ...
    {:ex_oauth2_provider, "~> 0.1.0"}
    # ...
  ]
end
```

Run `mix deps.get` to install it. Add the following to `config/config.exs`:

```elixir
config :ex_oauth2_provider, ExOauth2Provider,
  repo: MyApp.Repo,
  resource_owner_model: MyApp.User
```

You should use a resource owner model that already exists in your app, like your user model. If you don't have nay user model, you can add a migration like this:

```bash
mix ecto.gen.migration --change "    create table(:users) do\n      add :email, :string\n    end"
```

And use the model in [test/support/dummy/models/user.ex](test/support/dummy/models/user.ex).

3. Add migrations

```bash
mix ex_oauth2_provider.install
```

This will add all necessary migrations to your app.

## Plug API

### ExOauth2Provider.Plug.VerifyHeader

Looks for a token in the Authorization Header. If one is not found, this does nothing.

### ExOauth2Provider.Plug.EnsureAuthenticated

Looks for a previously verified token. If one is found, continues, otherwise it will call the `:unauthenticated` function of your handler.

When you ensure a session, you can declare an error handler. This can be done as part of a pipeline or inside a Phoenix controller.

```elixir
defmodule MyApp.MyController do
  use MyApp.Web, :controller

  plug ExOauth2Provider.Plug.EnsureAuthenticated, handler: MyApp.MyAuthErrorHandler
end
```
### ExOauth2Provider.Plug.EnsureScopes

Looks for a previously verified token. If one is found, confirms that all listed scopes are present in the token. If not, the `:unauthorized` function is called on your handler.

```elixir
defmodule MyApp.MyController do
  use MyApp.Web, :controller

  plug ExOauth2Provider.Plug.EnsureScopes, handler: MyApp.MyAuthErrorHandler, scopes: ~w(read write)
end
```

When scopes' sets are specified through a `:one_of` map, the token is searched for at least one matching scopes set to allow the request. The first set that matches will allow the request. If no set matches, the `:unauthorized` function is called.

```elixir
defmodule MyApp.MyController do
  use MyApp.Web, :controller

  plug ExOauth2Provider.Plug.EnsureScopes, handler: MyApp.MyAuthErrorHandler,
    one_of: [~w(admin), ~w(read write)]
end
```

### Current resource and token

Access to the current resource and token is useful. Note, you'll need to have run the VerifyHeader for token and resource access.

```elixir
ExOauth2Provider.Plug.current_token(conn) # access the token in the default location
ExOauth2Provider.Plug.current_token(conn, :secret) # access the token in the secret location
```

For the resource

```elixir
ExOauth2Provider.Plug.current_resource(conn) # Access the loaded resource in the default location
ExOauth2Provider.Plug.current_resource(conn, :secret) # Access the loaded resource in the secret location
```

## Acknowledgement

This library was made thanks to [doorkeeper](https://github.com/doorkeeper-gem/doorkeeper), [guardian](https://github.com/ueberauth/guardian) and [authable](https://github.com/mustafaturan/authable), that gave the conceptual building blocks.

Thanks to [Benjamin Schultzer](https://github.com/schultzer) for helping refactoring the code.

## LICENSE

(The MIT License)

Copyright (c) 2017 Dan Schultzer & the Contributors Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
0
