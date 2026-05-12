" ARXML syntax — extends XML with AUTOSAR-specific keyword highlighting
if exists("b:current_syntax")
  finish
endif

" Load XML base syntax
runtime! syntax/xml.vim
let b:current_syntax = "arxml"

