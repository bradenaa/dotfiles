-- Build steps for plugins installed with vim.pack. See `:help vim.pack-events`.
--
-- PackChanged fires after a plugin is installed, updated or deleted, so these
-- only run when plugin code changes, not on every startup.

local hooks = {
  ['telescope-fzf-native.nvim'] = function(data)
    if data.kind == 'install' or data.kind == 'update' then
      local res = vim.system({ 'make' }, { cwd = data.path }):wait()
      if res.code ~= 0 then
        vim.notify('telescope-fzf-native: make failed\n' .. (res.stderr or ''), vim.log.levels.ERROR)
      end
    end
  end,
  ['nvim-treesitter'] = function(data)
    -- Parsers must match the plugin's queries, so refresh them on update.
    -- (First install is handled by the install list in plugins/treesitter.lua.)
    if data.kind == 'update' then
      if not data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      require('nvim-treesitter').update()
    end
  end,
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-hooks', { clear = true }),
  callback = function(ev)
    local hook = hooks[ev.data.spec.name]
    if hook then
      hook(ev.data)
    end
  end,
})
