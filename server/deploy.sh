#!/bin/bash

echo What should the version be?
read VERSION

docker build -t kloudysky/redditklone:$VERSION .
docker push kloudysky/redditklone:$VERSION
ssh root@192.241.129.239 "docker pull kloudysky/redditklone:$VERSION && docker tag kloudysky/redditklone:$VERSION dokku/api:$VERSION && dokku deploy api $VERSION"