local status = {"classic", "arrow", "slant"}

if Theming.statusline == nil or Theming.statusline:gsub("%s+", "") == "" then
    require("feline.styles." .. status[1])
else
    for _, v in pairs(status) do
        if Theming.statusline:gsub("%s+", "") == v then
            require("feline.styles." .. v)
            return
        end
    end
end
