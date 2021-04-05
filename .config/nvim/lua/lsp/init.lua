if LSP.enabled == nil or LSP.enabled == false then
    require("lsp/completion")
elseif LSP.enabled == true then
    require("lsp/completion")
    require("lsp/servers")
end
