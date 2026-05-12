" ARXML syntax — extends XML with AUTOSAR-specific keyword highlighting
if exists("b:current_syntax")
  finish
endif

" Load XML base syntax
runtime! syntax/xml.vim
let b:current_syntax = "arxml"

" SHORT-NAME tag content — highlighted prominently
syn region arxmlShortName matchgroup=xmlTag start="<SHORT-NAME>" end="</SHORT-NAME>" keepend
hi def link arxmlShortName Title

" UUID attribute — dimmed to reduce visual noise
syn match arxmlUUID /UUID="[^"]*"/ containedin=xmlTag contains=NONE
hi def link arxmlUUID Comment
