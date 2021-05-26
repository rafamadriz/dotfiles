local status = {"classic", "arrow", "slant"}

if vim.g.neon_statusline == nil or vim.g.neon_statusline:gsub("%s+", "") == "" then
    require("feline.styles." .. status[1])
else
    for _, v in pairs(status) do
        if vim.g.neon_statusline:gsub("%s+", "") == v then
            require("feline.styles." .. v)
            return
        end
    end
end
