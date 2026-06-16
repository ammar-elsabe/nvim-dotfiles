vim.filetype.add({
	pattern = {
		[".*.bazelrc"] = "bazelrc",
	},
	extension = {
		svx = "markdown",
		bazelrc = "bazelrc",
		tf = "terraform",
		tfvars = "terraform-vars",
		circom = "circom",
	},
})

