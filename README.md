## oauth2_proxy

This repository contains **Dockerfile** of [oauth2_proxy](https://github.com/bitly/oauth2_proxy/)
for [Kubernetes](https://www.kubernetes.io/).

Bitly doesn't produce a docker build, and other folks seem to have not updated
in a very long time, probably due to the lack of a release.

### Base Docker Image

* [golang](https://hub.docker.com/_/golang/) 1.10.3-alpine3.7

### Usage
In a Kubernetes pod spec:
```
      - image: josebiro/oauth2_proxy:latest
        name: oauth2-proxy
        args:
          - --provider=oidc
          - --cookie-secure=false
          - --upstream=<upstream_hostport>
          - --http-address="0.0.0.0:4180"
          - --redirect-url="<redirect_host>/oauth2/callback"
          - --oidc-issuer-url=<oidc_issuer>
          - --email-domain=<domain>
          - --client-id=<id>
          - --client-secret=<secret>
        ports:
        - containerPort: 4180
```

### Build
You can build an image from the Dockerfile:
`docker build -t="josebiro/oauth2_proxy" github.com/josebiro/oauth2_proxy`


