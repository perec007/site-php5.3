#!/bin/bash -ex
registry=caspru/site-php5
docker build --squash -t $registry . && docker push $registry

