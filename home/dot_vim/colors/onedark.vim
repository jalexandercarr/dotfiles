" One Dark color scheme for Vim
" A dark color scheme inspired by Atom's One Dark theme

set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "onedark"

" Color definitions
let s:black = { "gui": "#282c34", "cterm": "235" }
let s:white = { "gui": "#abb2bf", "cterm": "145" }
let s:light_red = { "gui": "#e06c75", "cterm": "204" }
let s:dark_red = { "gui": "#be5046", "cterm": "196" }
let s:green = { "gui": "#98c379", "cterm": "114" }
let s:light_yellow = { "gui": "#e5c07b", "cterm": "180" }
let s:dark_yellow = { "gui": "#d19a66", "cterm": "173" }
let s:blue = { "gui": "#61afef", "cterm": "39" }
let s:magenta = { "gui": "#c678dd", "cterm": "170" }
let s:cyan = { "gui": "#56b6c2", "cterm": "38" }
let s:gutter_grey = { "gui": "#636d83", "cterm": "238" }
let s:comment_grey = { "gui": "#5c6370", "cterm": "59" }
let s:cursor_grey = { "gui": "#2c323c", "cterm": "236" }
let s:visual_grey = { "gui": "#3e4452", "cterm": "237" }
let s:menu_grey = { "gui": "#3e4452", "cterm": "237" }
let s:special_grey = { "gui": "#3b4048", "cterm": "238" }
let s:vertsplit = { "gui": "#181a1f", "cterm": "234" }

function! s:h(group, style)
    execute "highlight" a:group
        \ "guifg=" (has_key(a:style, "fg") ? a:style.fg.gui : "NONE")
        \ "guibg=" (has_key(a:style, "bg") ? a:style.bg.gui : "NONE")
        \ "guisp=" (has_key(a:style, "sp") ? a:style.sp.gui : "NONE")
        \ "gui=" (has_key(a:style, "gui") ? a:style.gui : "NONE")
        \ "ctermfg=" (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
        \ "ctermbg=" (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
        \ "cterm=" (has_key(a:style, "cterm") ? a:style.cterm : "NONE")
endfunction

" Syntax highlighting
call s:h("Normal", { "fg": s:white, "bg": s:black })
call s:h("Comment", { "fg": s:comment_grey, "gui": "italic", "cterm": "italic" })
call s:h("Constant", { "fg": s:cyan })
call s:h("String", { "fg": s:green })
call s:h("Character", { "fg": s:green })
call s:h("Number", { "fg": s:dark_yellow })
call s:h("Boolean", { "fg": s:dark_yellow })
call s:h("Float", { "fg": s:dark_yellow })
call s:h("Identifier", { "fg": s:light_red })
call s:h("Function", { "fg": s:blue })
call s:h("Statement", { "fg": s:magenta })
call s:h("Conditional", { "fg": s:magenta })
call s:h("Repeat", { "fg": s:magenta })
call s:h("Label", { "fg": s:magenta })
call s:h("Operator", { "fg": s:magenta })
call s:h("Keyword", { "fg": s:light_red })
call s:h("Exception", { "fg": s:magenta })
call s:h("PreProc", { "fg": s:light_yellow })
call s:h("Include", { "fg": s:blue })
call s:h("Define", { "fg": s:magenta })
call s:h("Macro", { "fg": s:magenta })
call s:h("PreCondit", { "fg": s:light_yellow })
call s:h("Type", { "fg": s:light_yellow })
call s:h("StorageClass", { "fg": s:light_yellow })
call s:h("Structure", { "fg": s:light_yellow })
call s:h("Typedef", { "fg": s:light_yellow })
call s:h("Special", { "fg": s:blue })
call s:h("SpecialChar", { "fg": s:dark_yellow })
call s:h("Tag", {})
call s:h("Delimiter", {})
call s:h("SpecialComment", { "fg": s:comment_grey })
call s:h("Debug", {})
call s:h("Underlined", { "gui": "underline", "cterm": "underline" })
call s:h("Ignore", {})
call s:h("Error", { "fg": s:light_red })
call s:h("Todo", { "fg": s:magenta })

" Editor UI
call s:h("ColorColumn", { "bg": s:cursor_grey })
call s:h("Conceal", {})
call s:h("Cursor", { "fg": s:black, "bg": s:blue })
call s:h("CursorIM", {})
call s:h("CursorColumn", { "bg": s:cursor_grey })
call s:h("CursorLine", { "bg": s:cursor_grey })
call s:h("Directory", { "fg": s:blue })
call s:h("DiffAdd", { "bg": s:green, "fg": s:black })
call s:h("DiffChange", { "fg": s:light_yellow, "gui": "underline", "cterm": "underline" })
call s:h("DiffDelete", { "bg": s:light_red, "fg": s:black })
call s:h("DiffText", { "bg": s:light_yellow, "fg": s:black })
call s:h("ErrorMsg", { "fg": s:light_red })
call s:h("VertSplit", { "fg": s:vertsplit })
call s:h("Folded", { "fg": s:comment_grey })
call s:h("FoldColumn", {})
call s:h("SignColumn", {})
call s:h("IncSearch", { "fg": s:light_yellow, "bg": s:comment_grey })
call s:h("LineNr", { "fg": s:gutter_grey })
call s:h("CursorLineNr", { "fg": s:white })
call s:h("MatchParen", { "fg": s:blue, "gui": "underline", "cterm": "underline" })
call s:h("ModeMsg", {})
call s:h("MoreMsg", {})
call s:h("NonText", { "fg": s:special_grey })
call s:h("Pmenu", { "bg": s:menu_grey })
call s:h("PmenuSel", { "fg": s:black, "bg": s:blue })
call s:h("PmenuSbar", { "bg": s:special_grey })
call s:h("PmenuThumb", { "bg": s:white })
call s:h("Question", { "fg": s:magenta })
call s:h("Search", { "fg": s:black, "bg": s:light_yellow })
call s:h("SpecialKey", { "fg": s:special_grey })
call s:h("SpellBad", { "fg": s:light_red, "gui": "underline", "cterm": "underline" })
call s:h("SpellCap", { "fg": s:dark_yellow })
call s:h("SpellLocal", { "fg": s:dark_yellow })
call s:h("SpellRare", { "fg": s:dark_yellow })
call s:h("StatusLine", { "fg": s:white, "bg": s:cursor_grey })
call s:h("StatusLineNC", { "fg": s:comment_grey })
call s:h("TabLine", { "fg": s:comment_grey })
call s:h("TabLineFill", {})
call s:h("TabLineSel", { "fg": s:white })
call s:h("Title", { "fg": s:green })
call s:h("Visual", { "bg": s:visual_grey })
call s:h("VisualNOS", { "bg": s:visual_grey })
call s:h("WarningMsg", { "fg": s:light_yellow })
call s:h("WildMenu", { "fg": s:black, "bg": s:blue })
