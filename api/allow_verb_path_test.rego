package api

import data.common.td

test_an_undefined_user_has_no_access_to_eves_bienenstich_recipe {
	not data.api.allow with input as {"username": "alex", "verb": "view", "path": "users/eve/documents/recipes/secret-bienenstich.pdf"}
		 with data.users as td.users
		 with data.groups as td.groups
		 with data.policies as td.policies
}

test_carol_has_access_to_eves_bienenstich_recipe {
	data.api.allow with input as {"username": "carol", "verb": "view", "path": "users/eve/documents/recipes/secret-bienenstich.pdf"}
		 with data.users as td.users
		 with data.groups as td.groups
		 with data.policies as td.policies
}

test_anyone_can_see_carols_report {
	test_result = data.api.who_can with input as {"verb": "view", "path": "users/carol/documents/report.pdf"}
		 with data.users as td.users
		 with data.groups as td.groups
		 with data.policies as td.policies

	test_result == {"carol", "dan", "eve", "alice", "bob"}
}

test_accesing_all_of_carols_documents_is_restricted {
	test_result = data.api.who_can with input as {"verb": "view", "path": "users/carol/documents/*"}
		 with data.users as td.users
		 with data.groups as td.groups
		 with data.policies as td.policies

	test_result == {"eve", "alice", "bob", "carol"}
}

test_writing_any_of_carols_documents_is_restricted_to_carol_and_management {
	test_result = data.api.who_can with input as {"verb": "write", "path": "users/carol/documents/people-i-like.txt"}
		 with data.users as td.users
		 with data.groups as td.groups
		 with data.policies as td.policies

	test_result == {"carol", "alice", "eve"}
}
