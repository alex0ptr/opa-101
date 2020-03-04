package api

import data.common.user_owned_policies
import data.policies

default allow = false

allow {
	user_owned_policies[input.username][_] == policies_matching_input[_]
}

who_can[username] {
	user_owned_policies[username][_] = policies_matching_input[_]
}

policies_matching_input[policy_name] {
	policies_with_matching_input_verb[policy_name] = policies_with_matching_input_path[_]
}

policies_with_matching_input_verb[policy_name] {
	policies[policy_name].verbs[_] == input.verb
}

policies_with_matching_input_verb[policy_name] {
	policies[policy_name].verbs[_] == "*"
}

policies_with_matching_input_path[policy_name] {
	policies[policy_name].paths[_] = input.path
}

policies_with_matching_input_path[policy_name] {
	path := policies[policy_name].paths[_]
	endswith(path, "*")
	startswith(input.path, trim_suffix(path, "*"))
}
