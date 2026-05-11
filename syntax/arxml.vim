" ARXML syntax — extends XML with AUTOSAR-specific keyword highlighting
if exists("b:current_syntax")
  finish
endif

" Load XML base syntax
runtime! syntax/xml.vim
let b:current_syntax = "arxml"

" AUTOSAR structural tags
syn keyword arxmlStructTag contained
  \ AR-PACKAGE AR-PACKAGES ELEMENTS AUTOSAR
  \ SW-COMPONENT-PROTOTYPE COMPONENT-IREF
  \ PORT-INTERFACE SENDER-RECEIVER-INTERFACE
  \ DATA-ELEMENT-PROTOTYPE VARIABLE-DATA-PROTOTYPE
  \ COMPOSITION-SW-COMPONENT-TYPE APPLICATION-SW-COMPONENT-TYPE
  \ SWC-INTERNAL-BEHAVIOR RUNNABLE-ENTITY
  \ PORT-PROTOTYPE P-PORT-PROTOTYPE R-PORT-PROTOTYPE
  \ SYSTEM FIBEX-ELEMENT-REF-CONDITIONAL

syn keyword arxmlMetaTag contained
  \ SHORT-NAME LONG-NAME CATEGORY ADMIN-DATA
  \ SDGS SDG SD

" *-REF tags (references to other elements)
syn match arxmlRefTag contained /<[A-Z-]*-REF\s*[^>]*>/
syn match arxmlRefValue />[^<]*\//me=e-1 contained

" Match the inner text of SHORT-NAME
syn region arxmlShortName
  \ start=/<SHORT-NAME>/
  \ end=/<\/SHORT-NAME>/
  \ contains=xmlTag,arxmlShortNameVal
  \ keepend

syn match arxmlShortNameVal />[^<]\+</ms=s+1,me=e-1 contained

" Match *-REF regions
syn region arxmlRef
  \ start=/<[A-Z-]\+-REF[^>]*>/
  \ end=/<\/[A-Z-]\+-REF>/
  \ contains=xmlTag,arxmlRefInner
  \ keepend

syn match arxmlRefInner />[^<]\+</ms=s+1,me=e-1 contained

hi def link arxmlShortNameVal Identifier
hi def link arxmlRefInner     Underlined
hi def link arxmlStructTag    Statement
hi def link arxmlMetaTag      Special
