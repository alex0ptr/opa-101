#doitlive speed: 2
#doitlive shell: /bin/zsh
#doitlive prompt: robbyrussell

bat dryrun/existing_resources/*
kubectl apply -f dryrun/existing_resources
kubectl get ingress --all-namespaces

code sync.yaml
kubectl apply -f sync.yaml

code dryrun/k8suniqueingresshost_template.yaml
kubectl apply -f dryrun/k8suniqueingresshost_template.yaml

code dryrun/unique-ingress-host.yaml
kubectl apply -f dryrun/unique-ingress-host.yaml

kubectl get K8sUniqueIngressHost.constraints.gatekeeper.sh  'unique-ingress-host' -o yaml
