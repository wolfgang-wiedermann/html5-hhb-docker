#!/bin/bash
#
# build an interactive mode container
#docker run -i -t html5-hhb:v1 -P bash
# build an daemon container
docker run -d -P -t -name html5-hhb html5-hhb:v1
