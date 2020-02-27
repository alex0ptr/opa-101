package k8s.reason

operations = {"CREATE", "UPDATE"}

deny[msg] {
	operations[input.request.operation]
	input_pods[pod]
	not pod.object.metadata.labels.billingCode
	msg := sprintf("%s has no label 'billingCode'", [pod.resource])
}

input_pods[return] {
	kinds_with_podspec = {"Deployment", "StatefulSet", "DaemonSet"}
	kind := kinds_with_podspec[input.request.kind.kind]
	object := input.request.object
	return := {
		"resource": sprintf("%s/%s", [kind, object.metadata.name]),
		"object": object.spec.template,
	}
}

input_pods[return] {
	input.request.kind.kind == "Pod"
	object := input.request.object
	return := {
		"resource": sprintf("%s/%s", ["Pod", object.metadata.name]),
		"object": object,
	}
}
