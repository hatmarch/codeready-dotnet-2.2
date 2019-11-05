#!/bin/bash

PROJECT=$1
if [ -z $PROJECT ]; then
    echo "Must set a target project"
    exit 1
fi

oc project $PROJECT
oc scale deployment che --replicas 0
sleep 1
oc scale deployment che --replicas 1

# watch the che deployment
echo "Hit ctrl-C to stop this script once AVAILABLE nodes goes to 1"
oc get deployment che -w
