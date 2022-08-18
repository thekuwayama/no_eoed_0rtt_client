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
172.17.0.1 - - [18/Aug/2022:13:24:32 +0000] "GET / HTTP/1.1" 200 3 "-" TLSv1.3 0.000 early=-
172.17.0.1 - - [18/Aug/2022:13:24:33 +0000] "GET / HTTP/1.1" 200 3 "-" TLSv1.3 0.000 early=1
```

You can run test client the following:

```sh-session
$ brew install openssl@1.1 readline

$ RUBY_CONFIGURE_OPTS="--with-readline-dir=`brew --prefix readline` --with-openssl-dir=`brew --prefix openssl@1.1`" rbenv install 3.1.2

$ gem install bundler

$ bundle install

$ bundle exec client.rb localhost:4433
HTTP/1.1 200 OK
Server: nginx/1.22.0
Date: Thu, 18 Aug 2022 13:24:32 GMT
Content-Type: text/html
Content-Length: 3
Last-Modified: Wed, 17 Aug 2022 07:06:30 GMT
Connection: close
ETag: "62fc9376-3"
Accept-Ranges: bytes

OK
HTTP/1.1 200 OK
Server: nginx/1.22.0
Date: Thu, 18 Aug 2022 13:24:33 GMT
Content-Type: text/html
Content-Length: 3
Last-Modified: Wed, 17 Aug 2022 07:06:30 GMT
Connection: close
ETag: "62fc9376-3"
Accept-Ranges: bytes

OK
```

If you need to specify host and port, you can run the following:

```sh-session
$ bundle exec client.rb $HOST:$PORT
```

You can browse the 0-RTT handshake.

<img src="/screenshot/wireshark_preferences.png" width="75%">
