--source: https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua

local on_windows = vim.loop.os_uname().version:match("Windows")

local function join_paths(...)
	local path_sep = on_windows and "\\" or "/"
	local result = table.concat({ ... }, path_sep)
	return result
end

vim.cmd([[set runtimepath=$VIMRUNTIME]])

local temp_dir = vim.loop.os_getenv("TEMP") or "/tmp"

vim.cmd("set packpath=" .. join_paths(temp_dir, "nvim", "site"))

local package_root = join_paths(temp_dir, "nvim", "site", "pack")
local install_path = join_paths(package_root, "packer", "start", "packer.nvim")
local compile_path = join_paths(install_path, "plugin", "packer_compiled.lua")

local function load_plugins()
	require("packer").startup({
		{
			"wbthomason/packer.nvim",
		},
		config = {
			package_root = package_root,
			compile_path = compile_path,
		},
	})
end

_G.load_config = function() end

if vim.fn.isdirectory(install_path) == 0 then
	vim.fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	load_plugins()
	require("packer").sync()
	vim.cmd([[autocmd User PackerComplete ++once lua load_config()]])
else
	load_plugins()
	require("packer").sync()
	_G.load_config()
end
