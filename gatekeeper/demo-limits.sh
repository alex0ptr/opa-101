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

pe "code templates/k8scontainterlimits_template.yaml"
pe "kubectl apply -f templates/k8scontainterlimits_template.yaml"
pe "code constraints/containers_must_be_limited.yaml"
pe "kubectl apply -f constraints/containers_must_be_limited.yaml"

pe "code bad_resources/opa_no_limits.yaml"
pe "kubectl apply -f bad_resources/opa_no_limits.yaml"

pe "code bad_resources/opa_limits_too_high.yaml"
pe "kubectl apply -f bad_resources/opa_limits_too_high.yaml"

pe "code good_resources/opa.yaml"
pe "kubectl apply -f good_resources/opa.yaml"

function cleanup {
    echo "cleaning up..."
    pei "kubectl delete -f templates/k8scontainterlimits_template.yaml"
    pei "kubectl delete ns production"
}

trap cleanup EXIT

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""