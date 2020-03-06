#doitlive speed: 2
#doitlive shell: /bin/zsh
#doitlive prompt: robbyrussell

code templates/k8scontainterlimits_template.yaml
kubectl apply -f templates/k8scontainterlimits_template.yaml
code constraints/containers_must_be_limited.yaml
kubectl apply -f constraints/containers_must_be_limited.yaml

bat bad_resources/opa_no_limits.yaml
kubectl apply -f bad_resources/opa_no_limits.yaml

bat bad_resources/opa_limits_too_high.yaml
kubectl apply -f bad_resources/opa_limits_too_high.yaml

bat good_resources/opa.yaml
kubectl apply -f good_resources/opa.yaml
