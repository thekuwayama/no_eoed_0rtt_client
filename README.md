# no\_eoed\_0rtt\_client

`no_eoed_0rtt_client` is the replication client that does NOT send EndOfEarlyData when 0-RTT.

## Usage

```sh-session
$ cd /path/to/no_eoed_0rtt_client
```

You can run test server the following:

```
$ docker pull thekuwayama/nginx-early-data

$ docker run -v `pwd`/fixtures:/tmp -p 4433:4433 -it thekuwayama/nginx-early-data nginx -g "daemon off;" -c /etc/nginx/nginx.conf
```

You can run test client the following:

```sh-session
$ brew install openssl@1.1 readline

$ RUBY_CONFIGURE_OPTS="--with-readline-dir=`brew --prefix readline` --with-openssl-dir=`brew --prefix openssl@1.1`" rbenv install 3.1.2

$ gem install bundler

$ bundle install

$ bundle exec client.rb localhost:4433
```
