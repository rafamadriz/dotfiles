-- This file is a minimal `init.lua` example for debuggin plugins.
-- Open with `nvim -u debug.lua`

local fn = vim.fn
local install_path = "/tmp/nvim/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"

vim.cmd [[set packpath=/tmp/nvim/site]]

local function load_plugins()
    local pack = require "packer"
    local use = pack.use
    pack.init { compile_path = compile_path }
    pack.startup {
        function()
            use "wbthomason/packer.nvim"
            -- Put plugins to install here:
        end,
        config = { package_root = "/tmp/nvim/site/pack" },
    }
end

_G.load_config = function()
    -- Put any configuration here:
end

if fn.isdirectory(install_path) == 0 then
    -- install packer
    fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
    load_plugins()
    require("packer").sync()
    vim.cmd "autocmd User PackerComplete ++once lua load_config()"
else
    load_plugins()
    _G.load_config()
end
