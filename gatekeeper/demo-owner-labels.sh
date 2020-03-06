#doitlive shell: /bin/zsh
#doitlive prompt: robbyrussell
code templates/k8srequiredlabels_template.yaml
kubectl apply -f templates/k8srequiredlabels_template.yaml
code constraints/owner_must_be_provided.yaml
kubectl apply -f constraints/owner_must_be_provided.yaml

kubectl create ns production
bat good_resources/namespace.yaml
kubectl apply -f good_resources/namespace.yaml

