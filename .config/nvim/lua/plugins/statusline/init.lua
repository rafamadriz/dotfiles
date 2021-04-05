local statusline = Theming.statusline

local styles = {"galaxy", "airline", "eviline", "gruvbox", "minimal"}

if statusline == "" or statusline == nil then
    require("plugins/statusline/" .. styles[1])
end

for k, v in pairs(styles) do
    if v == statusline then
        require("plugins/statusline/" .. v)
    end
end
