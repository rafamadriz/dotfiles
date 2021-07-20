require "core.global"
require "core.options"
require "core.mappings"
require "modules.plugins"
local async
async = vim.loop.new_async(vim.schedule_wrap(function()
    local compiled_plugins_path =
        vim.fn.expand "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim/plugin/packer_compiled.lua"
    if vim.fn.filereadable(compiled_plugins_path) > 0 then
        if vim.api.nvim_buf_get_name(0):len() == 0 then
            vim.cmd "Startify"
        end
    end
    async:close()
end))
async:send()
