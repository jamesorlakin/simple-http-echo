# Simple HTTP Echo

This is the world's simplest project - a small HTTP server that returns a dump of the HTTP request metadata passed to it with a status of 200.
Similar to the 'anything' endpoint of [httpbin](https://httpbin.org/) but works for all paths. It'll log requests too.

## Why?

I've found myself in multiple situations having to debug reverse proxies, including AWS ALB rules, AWS API Gateway headers, Kubernetes Ingress path matching, and Nginx `proxy_pass` with a URL defined from a variable (fun fact, in that situation Nginx will stop caching DNS, but `proxy_pass` becomes literal so you need to add regex matching to the `location` block *and* add remember to add query path values back - that was fun to investigate...).
I've also had proxies swallow `X-Forwarded-*` headers due to misconfigured middleware - this was the final straw to whip up this small utility.

## Usage

Simple HTTP echo is a simple Go binary with only one option: the `PORT` environment variable (which defaults to 3000 if not set).

There's a container image for ease of use with Docker or Kubernetes: [`jamesorlakin/simple-http-echo:latest`](https://hub.docker.com/r/jamesorlakin/simple-http-echo).

### Response Example

```
curl --verbose -H "X-Forwarded-Proto: some-test-header" http://localhost:3000/any-path-can-go-here
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /any-path-can-go-here HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> X-Forwarded-Proto: some-test-header
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Sat, 26 Nov 2022 10:13:04 GMT
< Content-Length: 528
< Content-Type: text/plain; charset=utf-8
< 
{
        "Method": "GET",
        "URL": {
                "Scheme": "",
                "Opaque": "",
                "User": null,
                "Host": "",
                "Path": "/any-path-can-go-here",
                "RawPath": "",
                "OmitHost": false,
                "ForceQuery": false,
                "RawQuery": "",
                "Fragment": "",
                "RawFragment": ""
        },
        "Proto": "HTTP/1.1",
        "Header": {
                "Accept": [
                        "*/*"
                ],
                "User-Agent": [
                        "curl/7.68.0"
                ],
                "X-Forwarded-Proto": [
                        "some-test-header"
                ]
        },
        "ContentLength": 0,
        "Host": "localhost:3000",
        "RemoteAddr": "127.0.0.1:38782",
        "RequestURI": "/any-path-can-go-here"
* Connection #0 to host localhost left intact
```
