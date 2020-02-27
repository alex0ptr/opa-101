## API Demo

### Working with the shell

Format:
```bash
opa fmt -w .
```

Test:
```bash
opa test -v .
```

Shell:
```bash
opa run --bundle --watch .
```

Run as Server:
```bash
opa run --bundle --watch --server .
```

### Example Queries

Look around: 
```
data
```

Which user has a policy that is named `mayViewEvesRecipes`?:
```
data.users[user].policies[_] == "mayViewEvesRecipes"
```

Who can access the recipe?:
```
data.api.who_can with input as { "verb": "view", "path": "users/eve/documents/recipes/secret-bienenstich.pdf" }
```

Can dan access carols report?:
```
data.api.allow with input as { "username": "dan", "verb": "view", "path": "users/carol/documents/report.pdf" }
```

Use HTTP to call the server:
```bash
curl localhost:8181/v1/data/api/who_can --data '{ "input": {"verb": "view", "path": "users/eve/documents/recipes/secret-bienenstich.pdf"} }'
```

## Gatekeeper Demo

Create a cluster and configure kubectl:
```bash
k3d create
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

Install gatekeeper using helm:
```bash
cd gatekeeper
kubectl apply -f gatekeeper-operator/gatekeeper.yaml
```
```


