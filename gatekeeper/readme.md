## Conftest

Test if deployments define root containers:
```bash
conftest test deployment.yaml
```

Test if service selector matches those of the deployment:
```bash
conftest test --combine *.yaml
```
