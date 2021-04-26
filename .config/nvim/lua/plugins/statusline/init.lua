local status = {"classic", "default", "slant", "minimal"}

if Theming.statusline == nil or Theming.statusline:gsub("%s+", "") == "" then
    require("plugins/statusline/styles/" .. status[1])
else
    for _, v in pairs(status) do
        if Theming.statusline:gsub("%s+", "") == v then
            require("plugins/statusline/styles/" .. v)
            break
        elseif Theming.statusline:gsub("%s+", "") == "default" then
            require("feline").setup()
            break
        end
    end
end
