function create-cluster {
    k3d cluster create

    kubectl apply -f gatekeeper-operator/gatekeeper.yaml
    kubectl config set-context $(kubectl config current-context) --namespace production
}

function delete-cluster {
    k3d cluster delete
}

function reset {
    kubectl delete -f agilebank/templates/ --wait=false
    kubectl delete ns production --wait=false
    clear
}

function demo-labels {
    cd agilebank
    doitlive play ../demo-owner-labels.sh
    cd -
    clear
}

function demo-limits {
    cd agilebank
    doitlive play ../demo-limits.sh
    cd -
    clear
}

function demo-inventory {
    cd agilebank
    doitlive play ../demo-inventory.sh
    cd -
    clear
}

