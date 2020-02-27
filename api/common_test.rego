package common

td = {
	"users": {
		"alice": {"policies": []},
		"bob": {"policies": ["mayViewCarolsFiles"]},
		"carol": {"policies": [
			"allAccessOnCarolsFiles",
			"mayViewEvesRecipes",
		]},
		"dan": {"policies": []},
		"eve": {"policies": []},
	},
	"groups": {
		"management": {
			"members": [
				"alice",
				"eve",
			],
			"policies": ["allAccess"],
		},
		"developer": {
			"members": [
				"bob",
				"carol",
				"dan",
				"eve",
			],
			"policies": ["mayViewCarolsReport"],
		},
	},
	"policies": {
		"allAccess": {
			"verbs": ["*"],
			"paths": ["*"],
		},
		"allAccessOnCarolsFiles": {
			"verbs": ["*"],
			"paths": [
				"users/carol/documents",
				"users/carol/documents/*",
			],
		},
		"mayViewCarolsFiles": {
			"verbs": [
				"list",
				"view",
			],
			"paths": [
				"users/carol/documents",
				"users/carol/documents/*",
			],
		},
		"mayViewCarolsReport": {
			"verbs": ["view"],
			"paths": ["users/carol/documents/report.pdf"],
		},
		"mayViewEvesRecipes": {
			"verbs": [
				"list",
				"view",
			],
			"paths": [
				"users/eve/documents/recipes",
				"users/eve/documents/recipes/*",
			],
		},
	},
}

test_users_are_assigned_policies {
	result := user_owned_policies with data.users as td.users with data.groups as td.groups with data.policies as td.policies

	count(result) == 5
	result.alice == {"allAccess"}
	result.bob == {"mayViewCarolsFiles", "mayViewCarolsReport"}
	result.carol == {"allAccessOnCarolsFiles", "mayViewCarolsReport", "mayViewEvesRecipes"}
	result.dan == {"mayViewCarolsReport"}
	result.eve == {"allAccess", "mayViewCarolsReport"}
}
