---@param bufnr? number
---@return integer|nil size in MiB if buffer is valid, nil otherwise
local function get_buf_size(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local ok, stats = pcall(function() return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr)) end)
    if not (ok and stats) then return end
    return math.floor(0.5 + (stats.size / (1024 * 1024)))
end

local disable_treesitter = function()
    local ok, ts_config = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    local modules = ts_config.available_modules()

    for _, module in pairs(modules) do
        if ts_config.get_module(module).enable then vim.cmd.TSBufDisable(module) end
    end
end

local disable_treesitter_context = function()
    pcall(function() require("treesitter-context").disable() end)
end

-- When editing huge files, any action gets a huge delay, I found that
-- the main culprits of this are foldmethod when set to expr and treesitter.
-- The other options doesn't seem to make a difference.
-- This improves the delay to a point where is not very notcible.
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    desc = "Improve performance on big files",
    callback = function(args)
        if get_buf_size(args.buf) > 2 then
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.undolevels = 50
            vim.opt_local.relativenumber = false
            disable_treesitter()
            disable_treesitter_context()
        end
    end,
})
