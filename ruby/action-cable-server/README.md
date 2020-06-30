# Rails Action Cable Server

## Dependencies

* Ruby 2.5+
* Redis

```sh
bundle install
```

### Rails version

To run the server:

```sh
bundle exec rails s -p 8080 -e production
```

You can specify the number of Puma workers:

```sh
WEB_CONCURRENCY=4 bundle exec rails s -p 8080 -e production
```

The raw message to send to a connection to join a channel is as follows:

```sh
{"command":"subscribe","identifier":"{\"channel\":\"BenchmarkChannel\"}"}
```

To run a patched version of Action Cable run with `PATCH` env variable:

```sh
PATCH=1 WEB_CONCURRENCY=4 bundle exec rails s -p 8080 -e production
```

For more inforrmation about the patch see [this issue](https://github.com/rails/rails/issues/26999).

### AnyCable version

**NOTE:** [`anycable-go`](https://github.com/anycable/anycable-go) must be installed.

Run using the following command:

```sh
ADAPTER=any_cable RAILS_ENV=production bundle exec anycable --server-command="anycable-go"
```
