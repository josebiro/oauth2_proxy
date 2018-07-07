FROM golang:1.10.3-alpine3.7
LABEL maintainer="Joseph Bironas <josebiro@gmail.com>"

# Install CA certificates
RUN apk add --no-cache --virtual=build-dependencies ca-certificates git

RUN git clone https://github.com/bitly/oauth2_proxy.git /go/src/app

RUN go get -d -v github.com/bitly/oauth2_proxy
RUN go install -v github.com/bitly/oauth2_proxy

RUN rm -rf /go/src/app

VOLUME /config

# Expose the ports we need and setup the ENTRYPOINT w/ the default argument
# to be pass in.
EXPOSE 8080 4180

ENTRYPOINT [ "oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
