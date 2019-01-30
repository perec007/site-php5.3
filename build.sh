#!/bin/bash -ex
registry=caspru/site-php5.3
docker build --squash -t $registry . && docker push $registry

