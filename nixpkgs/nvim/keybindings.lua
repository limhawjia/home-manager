_G.smart_jump = function(dir)
  if vim.v.count > 1 then
    return "m' " .. vim.v.count .. dir
  else
    return dir
  end
end

vim.api.nvim_set_keymap('n', '<C-_>', ":noh<CR>", {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', 'k', "v:lua.smart_jump('k')", {noremap = true, expr = true})
vim.api.nvim_set_keymap('n', 'j', "v:lua.smart_jump('j')", {noremap = true, expr = true})

vim.cmd("cnoreabbrev <silent> trim %s/\\s\\+$//e")
vim.cmd("cnoreabbrev <silent> tt tabnew")
vim.cmd("cnoreabbrev <silent> tp tabprevious")
vim.cmd("cnoreabbrev <silent> tn tabnext")
vim.cmd("cnoreabbrev <silent> bq :bp<bar>sp<bar>bn<bar>bd<CR>")
