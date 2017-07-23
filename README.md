
# UrlShortner

UrlShortner is an rails application which gives shortened URL from the original URL.

# Features

UrlShorner has web front end and api service.

# Authentication

Authentication for web front end is through devise and for api service it is through JSON web token

# Installation
```sh
git clone https://github.com/ethirajsrinivasan/UrlShortner.gito
cd UrlShortner
bundle install
rake db:setup
rake db:migrate
rails server
```
UrlShortner is up and running

# API EndPoint

To get authentication token
```sh
http://localhost:3000/authenticate?email=xxxxxxxx@gmail.com&password=xxxxxxx
```

To get short url
```sh
http://localhost:3000/url_shortners/fetch_short_url?url=yahoo.com
```
To get statistics about short url
```sh
http://localhost:3000/url_shortners/sAe0Lj/stats
```
Note:
Include auth token in the header as below

Authorization: 'auth_token'