package common

import data.users
import data.groups

user_owned_policies[username] = combined_policy_names {
	users[username]
	user_policies := {user_policy | user_policy := users[username].policies[_]}
	group_policies := {group_policy |
		username == groups[group].members[_]
		group_policy := data.groups[group].policies[_]
	}

	combined_policy_names := user_policies | group_policies
}
