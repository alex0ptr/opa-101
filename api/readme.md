## Playing with OPA

Start a OPA shell:
```bash
opa run
```

Put some data into a variable:

```rego

cities := {
    "München": {
        "population": 1456000,
        "area": 310
    },
    "Rosenheim": {
        "population": 63000,
        "area": 37
    },
    "Mainz": {
        "population": 209000,
        "area": 97
    },
    "Darmstadt": {
        "population": 158000,
        "area": 122
    }
}
students := {
    "Berlin": 180000,
    "München": 120000,
    "Hamburg": 84000,
    "Darmstadt": 40000,
    "Mainz": 40000,
    "Rosenheim": 5300
}

```

Determine which cities are good for hiring:
```
s := students[city]; c := cities[city]; s / c.population > 0.25
```

## API Demo

Determine ### Working with the shell

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