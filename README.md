Heroku Run Scripts
==================

This slug has no web or worker processes it just is for running scripts inside
the heroku dyno environment.

## Build & Upload nginx to S3

```sh
heroku config:set AWS_REGION=us-east-1
heroku config:set AWS_ACCESS_KEY=MYKEY
heroku config:set AWS_SECRET_KEY=MYSECRET
heroku config:set BUILD_BUCKET=my-builds
heroku run scripts/build_nginx.rb
```

Fetch build
```rb
require('aws-sdk')
Aws::S3::Object.new(bucket_name: 'my-builds', key: 'nginx-1.8.0-build.tar.gz', region: 'us-east-1').get(response_target: 'nginx-1.8.0-build.tar.gz')
```
