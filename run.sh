#!/bin/bash
#
# build an interactive mode container
#docker run -i -t html5-hhb:v1 -P bash
# build an daemon container
docker run -d -p 8080:80 -p 127.0.0.1:4444:22 -t --name html5-hhb html5-hhb:v1
