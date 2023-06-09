# SSO

This is a Phoenix based SSO provider.
SSO workflow endpoints:
- GET /login (funs with 2 diff arities). For redirect - receives params: client_id, redirect_url, scope, state, response_type=code. Redirects to accept, then redirect url. Returns code, state (same as in params)
- POST /accept_and_redirect
- GET /register_app - create client id and secret and store in DB (with redirect_url from param)
- POST /get_access_token. Params: client id, code, redirect_url, grant type, code verifier. Returns access_token (refresh_token)
- GET /get_user_email - finish sign in. Params: access token (header: authorisation. Bearer _access_token_)


### Installing

This app requires Postgresql.
Before you start the server, run


```
mix deps.get
```

### Starting the server
To start the server on default port (80), run

```
mix phx.server
```

### Running the tests

To run the tests, run

```
mix test
```

## Author

Alisa Berdichevskaia [Amber-Cloud](https://github.com/Amber-Cloud)