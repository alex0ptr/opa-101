package k8s.reason

test_a_daemonset_pod_template_is_extracted {
	object := {
		"metadata": {"labels": {"name": "fluentd-elasticsearch"}},
		"spec": {
			"tolerations": [{
				"key": "node-role.kubernetes.io/master",
				"effect": "NoSchedule",
			}],
			"containers": [{
				"name": "fluentd-elasticsearch",
				"image": "quay.io/fluentd_elasticsearch/fluentd:v2.5.2",
				"resources": {
					"limits": {"memory": "200Mi"},
					"requests": {
						"cpu": "100m",
						"memory": "200Mi",
					},
				},
				"volumeMounts": [
					{
						"name": "varlog",
						"mountPath": "/var/log",
					},
					{
						"name": "varlibdockercontainers",
						"mountPath": "/var/lib/docker/containers",
						"readOnly": true,
					},
				],
			}],
			"terminationGracePeriodSeconds": 30,
			"volumes": [
				{
					"name": "varlog",
					"hostPath": {"path": "/var/log"},
				},
				{
					"name": "varlibdockercontainers",
					"hostPath": {"path": "/var/lib/docker/containers"},
				},
			],
		},
	}

	result := input_pods[_] with input as {
		"kind": "AdmissionReview",
		"request": {
			"operation": "CREATE",
			"kind": {
				"kind": "DaemonSet",
				"version": "v1",
			},
			"object": {
				"metadata": {
					"name": "fluentd-elasticsearch",
					"namespace": "kube-system",
					"labels": {"k8s-app": "fluentd-logging"},
				},
				"spec": {
					"selector": {"matchLabels": {"name": "fluentd-elasticsearch"}},
					"template": object,
				},
			},
		},
	}

	result.resource == "DaemonSet/fluentd-elasticsearch"
	result.object == object
}

test_a_pod_definition_is_extracted {
	object := {
		"metadata": {"name": "myapp"},
		"spec": {"containers": [
			{
				"image": "nginx",
				"name": "nginx-frontend",
			},
			{
				"image": "mysql",
				"name": "mysql-backend",
			},
		]},
	}

	result := input_pods[_] with input as {
		"kind": "AdmissionReview",
		"request": {
			"operation": "CREATE",
			"kind": {
				"kind": "Pod",
				"version": "v1",
			},
			"object": object,
		},
	}

	result.resource == "Pod/myapp"
	result.object == object
}

test_a_pod_without_a_billing_label_may_not_be_created {
	object := {
		"metadata": {"name": "myapp"},
		"spec": {"containers": [
			{
				"image": "nginx",
				"name": "nginx-frontend",
			},
			{
				"image": "mysql",
				"name": "mysql-backend",
			},
		]},
	}

	result := deny with input as {
		"kind": "AdmissionReview",
		"request": {
			"operation": "CREATE",
			"kind": {
				"kind": "Pod",
				"version": "v1",
			},
			"object": object,
		},
	}

	endswith(result[_], "has no label 'billingCode'")
}

test_a_daemonset_with_a_billing_label_may_be_created {
	result := deny with input as {
		"kind": "AdmissionReview",
		"request": {
			"operation": "CREATE",
			"kind": {
				"kind": "DaemonSet",
				"version": "v1",
			},
			"object": {
				"metadata": {
					"name": "fluentd-elasticsearch",
					"namespace": "kube-system",
					"labels": {"k8s-app": "fluentd-logging"},
				},
				"spec": {
					"selector": {"matchLabels": {"name": "fluentd-elasticsearch"}},
					"template": {
						"metadata": {"labels": {
							"name": "fluentd-elasticsearch",
							"billingCode": "orange-456",
						}},
						"spec": {
							"tolerations": [{
								"key": "node-role.kubernetes.io/master",
								"effect": "NoSchedule",
							}],
							"containers": [{
								"name": "fluentd-elasticsearch",
								"image": "quay.io/fluentd_elasticsearch/fluentd:v2.5.2",
								"resources": {
									"limits": {"memory": "200Mi"},
									"requests": {
										"cpu": "100m",
										"memory": "200Mi",
									},
								},
								"volumeMounts": [
									{
										"name": "varlog",
										"mountPath": "/var/log",
									},
									{
										"name": "varlibdockercontainers",
										"mountPath": "/var/lib/docker/containers",
										"readOnly": true,
									},
								],
							}],
							"terminationGracePeriodSeconds": 30,
							"volumes": [
								{
									"name": "varlog",
									"hostPath": {"path": "/var/log"},
								},
								{
									"name": "varlibdockercontainers",
									"hostPath": {"path": "/var/lib/docker/containers"},
								},
							],
						},
					},
				},
			},
		},
	}
	count(result) == 0
}
