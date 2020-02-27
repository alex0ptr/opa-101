#!/usr/bin/env bash

#!/usr/bin/env bash

########################
# include the magic
########################
. ../demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=30

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear

# print and execute immediately
function pei {
    NO_WAIT=true pe "$1"
}

## The Demo Goes Here ##

pei "cd agilebank"
pei "kubectl create namespace production"
pei "kubectl config set-context $(kubectl config current-context) --namespace production"

pei "cat dryrun/existing_resources/*" 
pe "kubectl apply -f dryrun/existing_resources" 
pei "kubectl get ingress --all-namespaces"

pe "code sync.yaml"
pe "kubectl apply -f sync.yaml"

pe "code dryrun/k8suniqueingresshost_template.yaml"
pe "kubectl apply -f dryrun/k8suniqueingresshost_template.yaml"

pe "code dryrun/unique-ingress-host.yaml"
pe "kubectl apply -f dryrun/unique-ingress-host.yaml"


pe "kubectl get K8sUniqueIngressHost.constraints.gatekeeper.sh  unique-ingress-host -o yaml"


function cleanup {
    echo "cleaning up..."
    pei "kubectl delete -f dryrun/k8suniqueingresshost_template.yaml"
    pei "kubectl delete ns production"
}

trap cleanup EXIT

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""