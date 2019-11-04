#!/bin/bash
# NOTE: This script requires that one is logged into OCP with sufficient privileges

SCRIPT_DIR=$(dirname $0)
echo "script dir is: $SCRIPT_DIR"
KUBERNETES_DIR="$SCRIPT_DIR/../kubernetes/"

NAMESPACE=$1

if [ -z "$NAMESPACE" ]; then
    echo "Need to provide namespace to install the components."
    return 1
fi

# pre-reqs
# oc adm policy add-scc-to-group anyuid system:authenticated


oc new-project $NAMESPACE
oc project $NAMESPACE

# oc adm policy add-scc-to-user privileged -z default -n tutorial

#
# Setup Initial Services
#
cd "$KUBERNETES_DIR"

#
# Setup the Recommendation Service
#
oc apply -f Recommendation-Deployment.yml 
oc apply -f Recommendation-Service.yml 

#
# Setup the Preference Service
#
oc apply -f Preference-Deployment.yml 
oc apply -f Preference-Service.yml

oc expose svc preference

#
# Initial deployments of the Customer Service
# this will be done by the AzureDevOps pipeline
#

# NOTE: $NAMESPACE needs to be configured in the release pipeline for azure devops so that the oc command knows
# to deploy to that namespace
oc apply -f Customer-Initial-Deployment.yml
oc apply -f Customer-Initial-Service.yml

# create a route
oc expose svc customer-v2
