---@type vim.lsp.Config
return {
  -- Leave hover to ty, which shows types and docs.
  on_init = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
