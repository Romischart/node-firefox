# Node docker image with latest stable firefox

[![Build Status](https://travis-ci.com/Romischart/node-firefox.svg?branch=master)](https://travis-ci.com/Romischart/node-firefox)

> Fully dockerized latest stable firefox based on debian:buster-slim with nodejs & yarn preinstalled

## Why
This project enables you to use a real firefox for example for e2e testing (with tools like testcafe) directly in CI.

It could be used as base for your custom image.

**Global testcafe example:**
```dockerfile
FROM romischart/node-firefox:latest

RUN yarn global add testcafe \
    && mkdir -p /usr/src/app/testcafe

WORKDIR /usr/src/app/testcafe
```

and now you need to build the custom image and run the tests with docker volume mounting:
```bash
docker build -t testcafe-firefox .

docker run -v /path/to/tests:/usr/src/app/testcafe testcafe-firefox:latest testcafe chrome:headless -s *.testcafe.js
```

**Local testcafe example:**
```bash
docker run -it -v /path/to/tests:/home/node romischart/node-firefox:latest yarn testcafe firefox:headless
```

## Custom node version
You can build your own image with your custom node version, you need only to pass `NODE_VERSION` argument at build time:

```dockerfile
FROM romischart/node-firefox:latest
```

```bash
docker build . -t custom-node-version --build-arg NODE_VERSION=12.16.1
```
