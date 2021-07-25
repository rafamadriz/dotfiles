local M = {}

M.config = function()
    local status = { "classic", "arrow", "slant" }

    if vim.g.code_statusline == nil or vim.g.code_statusline:gsub("%s+", "") == "" then
        require("feline.styles." .. status[1])
    else
        for _, v in pairs(status) do
            if vim.g.code_statusline:gsub("%s+", "") == v then
                require("feline.styles." .. v)
                return
            end
        end
    end
end

return M
