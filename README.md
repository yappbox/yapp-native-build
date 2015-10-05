Heroku Run Scripts
==================

This slug has no web or worker processes it just is for running scripts inside
the heroku dyno environment.

## Build & Upload nginx to S3

```
heroku config:set BUILD_BUCKET=my-builds
heroku config:set AWS_ACCESS_KEY=MYKEY
heroku config:set AWS_SECRET_KEY=MYSECRET
heroku run scripts/build_nginx.rb
```
