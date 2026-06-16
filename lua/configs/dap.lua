require("dapui").setup()
-- dap registration
-- require("dap-go").setup()
local dap = require("dap")
dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "/home/ammarelsabe/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}
local basiccpptoolsconfig = {
	name = "Launch file",
	type = "cppdbg",
	request = "launch",
	program = function()
		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	end,
	cwd = "${workspaceFolder}",
	stopAtEntry = true,
}
dap.configurations.cpp = { basiccpptoolsconfig }
dap.configurations.rust = { basiccpptoolsconfig }
dap.configurations.c = { basiccpptoolsconfig }
-- keymaps
local map = vim.keymap.set
map("n", "<Leader>mc", function()
	require("dap").continue()
end, { desc = "Continue Debugging" })

map("n", "<Leader>ms", function()
	require("dap").step_over()
end, { desc = "Step Over" })

map("n", "<Leader>mS", function()
	require("dap").step_into()
end, { desc = "Step Into" })

map("n", "<Leader>mo", function()
	require("dap").step_out()
end, { desc = "Step Out" })

map("n", "<Leader>mb", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

map("n", "<Leader>mB", function()
	require("dap").set_breakpoint()
end, { desc = "Set Breakpoint" })

map("n", "<Leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Log Point" })

map("n", "<Leader>mr", function()
	require("dap").repl.open()
end, { desc = "Open REPL" })

map("n", "<Leader>ml", function()
	require("dap").run_last()
end, { desc = "Run Last Configuration" })

map({ "n", "v" }, "<Leader>mh", function()
	require("dap.ui.widgets").hover()
end, { desc = "Hover" })

map({ "n", "v" }, "<Leader>mp", function()
	require("dap.ui.widgets").preview()
end, { desc = "Preview" })

map("n", "<Leader>mf", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "Frames" })

map("n", "<Leader>mm", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "Scopes" })
