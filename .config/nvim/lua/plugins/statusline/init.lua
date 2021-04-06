local styles = {"galaxy", "airline", "eviline", "gruvbox", "minimal", "rounded"}

if Theming.statusline == nil or Theming.statusline:gsub("%s+", "") == "" then
    require("plugins/statusline/" .. styles[1])
else
    local statusline = Theming.statusline:gsub("%s+", "")
    for k, v in pairs(styles) do
        if v == statusline then
            require("plugins/statusline/" .. v)
        end
    end
end
