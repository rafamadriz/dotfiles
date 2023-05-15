local M = {}

M.servers = {
    rust_analyzer = {
        checkOnSave = { command = "clippy" },
    },
    lua_ls = {
        settings = {
            Lua = {
                completion = { callSnippet = "Replace" },
                -- This won't work, hints are not implemented yet in neovim
                -- reference: https://github.com/neovim/neovim/issues/18086
                hint = { enable = true },
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
}

M.config = function(name)
    local config = name and M.servers[name] or {}
    if not config then return end
    if type(config) == "function" then config = config() end
    return config
end

return M
