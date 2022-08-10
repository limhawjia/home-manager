vim.cmd [[
augroup lua
  autocmd!
  autocmd Filetype lua setlocal sw=2 sts=2 ts=2
  autocmd Filetype lua setlocal textwidth=120
  autocmd Filetype lua setlocal colorcolumn=121
augroup lua

augroup python
  autocmd Filetype python setlocal sw=4 sts=4 ts=4
  autocmd Filetype python setlocal textwidth=120
  autocmd Filetype python setlocal colorcolumn=121
augroup python

augroup web
  autocmd!
  autocmd Filetype html       setlocal sw=2 sts=2 ts=2
  autocmd Filetype css        setlocal sw=2 sts=2 ts=2
  autocmd Filetype javascript setlocal sw=2 sts=2 ts=2
  autocmd Filetype typescript setlocal sw=2 sts=2 ts=2
  autocmd Filetype json       setlocal sw=2 sts=2 ts=2
augroup end

augroup cpp
  autocmd!
  autocmd Filetype cpp setlocal sw=2 sts=2 ts=2
augroup end

augroup markdown
  autocmd!
  autocmd Filetype markdown setlocal sw=2 sts=2 ts=2
  autocmd Filetype markdown setlocal textwidth=0
  autocmd Filetype markdown setlocal colorcolumn=
  autocmd Filetype markdown setlocal wrap
  autocmd Filetype markdown setlocal linebreak
  autocmd Filetype markdown setlocal spell
augroup end

augroup yaml
  autocmd!
  autocmd Filetype yaml setlocal sw=2 sts=2 ts=2
  autocmd Filetype yaml setlocal textwidth=0
  autocmd Filetype yaml setlocal colorcolumn=
  autocmd Filetype yaml setlocal linebreak
augroup end

augroup go
  autocmd!
  autocmd Filetype go setlocal expandtab!
  autocmd Filetype go setlocal sw=8 sts=0 ts=8
augroup end
]]
