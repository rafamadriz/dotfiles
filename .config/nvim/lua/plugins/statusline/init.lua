local styles = {"galaxy", "airline", "eviline", "gruvbox", "minimal"}

if Theming.statusline == nil or Theming.statusline:gsub("%s+", "") == "" then
    require("plugins/statusline/" .. styles[1]d
else
    local statusline = Theming.statusline:gsub("%s+", "")
    for _, v in pairs(styles) do
        if v == statusline then
            require("plugins/statusline/" .. v)
        end
    end
end
