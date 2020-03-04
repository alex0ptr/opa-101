package main

deny[msg] {
  deployment := input["deployment.yaml"]["spec"]["selector"]["matchLabels"]["app"]
  service := input["service.yaml"]["spec"]["selector"]["app"]

  deployment != service

  msg = sprintf("Expected these values to be the same but received %v for deployment and %v for service", [deployment, service])
}
