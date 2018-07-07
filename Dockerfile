# Setup builder...
FROM golang:1.10.3-alpine3.7

RUN apk add --no-cache --virtual=build-dependencies git
RUN git clone https://github.com/bitly/oauth2_proxy.git /go/src/app
RUN go get -d -v github.com/bitly/oauth2_proxy
RUN go install -v github.com/bitly/oauth2_proxy


# Setup image
FROM alpine:3.8
LABEL maintainer="Joseph Bironas <josebiro@gmail.com>"

RUN apk add --no-cache --virtual=build-dependencies ca-certificates
COPY --from=0 /go/bin/oauth2_proxy /usr/local/bin/oauth2_proxy

VOLUME /config
EXPOSE 8080 4180
ENTRYPOINT [ "/usr/local/bin/oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]

