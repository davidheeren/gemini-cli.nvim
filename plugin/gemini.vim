" Bootstrap the gemini-cli plugin
if !exists('g:gemini_loaded')
  lua require('gemini').setup()
  let g:gemini_loaded = 1
endif
