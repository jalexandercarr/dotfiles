" Gruvbox color scheme for Vim (Minimal version)
" A retro groove color scheme

set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "gruvbox"

" Color palette
let s:bg0 = { "gui": "#282828", "cterm": "235" }
let s:bg1 = { "gui": "#3c3836", "cterm": "237" }
let s:bg2 = { "gui": "#504945", "cterm": "239" }
let s:bg3 = { "gui": "#665c54", "cterm": "241" }
let s:fg0 = { "gui": "#fbf1c7", "cterm": "229" }
let s:fg1 = { "gui": "#ebdbb2", "cterm": "223" }
let s:fg2 = { "gui": "#d5c4a1", "cterm": "250" }
let s:fg3 = { "gui": "#bdae93", "cterm": "248" }
let s:fg4 = { "gui": "#a89984", "cterm": "246" }
let s:red = { "gui": "#fb4934", "cterm": "167" }
let s:green = { "gui": "#b8bb26", "cterm": "142" }
let s:yellow = { "gui": "#fabd2f", "cterm": "214" }
let s:blue = { "gui": "#83a598", "cterm": "109" }
let s:purple = { "gui": "#d3869b", "cterm": "175" }
let s:aqua = { "gui": "#8ec07c", "cterm": "108" }
let s:orange = { "gui": "#fe8019", "cterm": "208" }
let s:gray = { "gui": "#928374", "cterm": "245" }

function! s:h(group, style)
    execute "highlight" a:group
        \ "guifg=" (has_key(a:style, "fg") ? a:style.fg.gui : "NONE")
        \ "guibg=" (has_key(a:style, "bg") ? a:style.bg.gui : "NONE")
        \ "gui=" (has_key(a:style, "gui") ? a:style.gui : "NONE")
        \ "ctermfg=" (has_key(a:style, "fg") ? a:style.fg.cterm : "NONE")
        \ "ctermbg=" (has_key(a:style, "bg") ? a:style.bg.cterm : "NONE")
        \ "cterm=" (has_key(a:style, "cterm") ? a:style.cterm : "NONE")
endfunction

" Syntax highlighting
call s:h("Normal", { "fg": s:fg1, "bg": s:bg0 })
call s:h("Comment", { "fg": s:gray, "gui": "italic", "cterm": "italic" })
call s:h("Constant", { "fg": s:purple })
call s:h("String", { "fg": s:green })
call s:h("Character", { "fg": s:green })
call s:h("Number", { "fg": s:purple })
call s:h("Boolean", { "fg": s:purple })
call s:h("Float", { "fg": s:purple })
call s:h("Identifier", { "fg": s:blue })
call s:h("Function", { "fg": s:green })
call s:h("Statement", { "fg": s:red })
call s:h("Conditional", { "fg": s:red })
call s:h("Repeat", { "fg": s:red })
call s:h("Label", { "fg": s:red })
call s:h("Operator", { "fg": s:fg1 })
call s:h("Keyword", { "fg": s:red })
call s:h("Exception", { "fg": s:red })
call s:h("PreProc", { "fg": s:aqua })
call s:h("Include", { "fg": s:aqua })
call s:h("Define", { "fg": s:aqua })
call s:h("Macro", { "fg": s:aqua })
call s:h("PreCondit", { "fg": s:aqua })
call s:h("Type", { "fg": s:yellow })
call s:h("StorageClass", { "fg": s:orange })
call s:h("Structure", { "fg": s:aqua })
call s:h("Typedef", { "fg": s:yellow })
call s:h("Special", { "fg": s:orange })
call s:h("SpecialChar", { "fg": s:red })
call s:h("Tag", { "fg": s:aqua })
call s:h("Delimiter", { "fg": s:fg1 })
call s:h("SpecialComment", { "fg": s:gray })
call s:h("Debug", { "fg": s:red })
call s:h("Underlined", { "fg": s:blue, "gui": "underline", "cterm": "underline" })
call s:h("Ignore", {})
call s:h("Error", { "fg": s:red, "bg": s:bg0, "gui": "bold", "cterm": "bold" })
call s:h("Todo", { "fg": s:fg0, "bg": s:bg0, "gui": "bold", "cterm": "bold" })

" Editor UI
call s:h("ColorColumn", { "bg": s:bg1 })
call s:h("Cursor", { "fg": s:bg0, "bg": s:fg0 })
call s:h("CursorColumn", { "bg": s:bg1 })
call s:h("CursorLine", { "bg": s:bg1 })
call s:h("Directory", { "fg": s:green })
call s:h("DiffAdd", { "fg": s:green, "bg": s:bg0 })
call s:h("DiffChange", { "fg": s:aqua, "bg": s:bg0 })
call s:h("DiffDelete", { "fg": s:red, "bg": s:bg0 })
call s:h("DiffText", { "fg": s:yellow, "bg": s:bg0 })
call s:h("ErrorMsg", { "fg": s:bg0, "bg": s:red })
call s:h("VertSplit", { "fg": s:bg3, "bg": s:bg0 })
call s:h("Folded", { "fg": s:gray, "bg": s:bg1 })
call s:h("FoldColumn", { "fg": s:gray, "bg": s:bg1 })
call s:h("SignColumn", { "bg": s:bg1 })
call s:h("IncSearch", { "fg": s:bg0, "bg": s:orange })
call s:h("LineNr", { "fg": s:bg3 })
call s:h("CursorLineNr", { "fg": s:yellow, "bg": s:bg1 })
call s:h("MatchParen", { "bg": s:bg3, "gui": "bold", "cterm": "bold" })
call s:h("ModeMsg", { "fg": s:yellow })
call s:h("MoreMsg", { "fg": s:yellow })
call s:h("NonText", { "fg": s:bg2 })
call s:h("Pmenu", { "fg": s:fg1, "bg": s:bg2 })
call s:h("PmenuSel", { "fg": s:bg2, "bg": s:blue })
call s:h("PmenuSbar", { "bg": s:bg2 })
call s:h("PmenuThumb", { "bg": s:bg3 })
call s:h("Question", { "fg": s:orange })
call s:h("Search", { "fg": s:bg0, "bg": s:yellow })
call s:h("SpecialKey", { "fg": s:bg2 })
call s:h("SpellBad", { "gui": "undercurl", "cterm": "underline" })
call s:h("SpellCap", { "gui": "undercurl", "cterm": "underline" })
call s:h("SpellLocal", { "gui": "undercurl", "cterm": "underline" })
call s:h("SpellRare", { "gui": "undercurl", "cterm": "underline" })
call s:h("StatusLine", { "fg": s:bg2, "bg": s:fg1 })
call s:h("StatusLineNC", { "fg": s:bg1, "bg": s:fg4 })
call s:h("TabLine", { "fg": s:bg3, "bg": s:bg1 })
call s:h("TabLineFill", { "fg": s:bg3, "bg": s:bg1 })
call s:h("TabLineSel", { "fg": s:green, "bg": s:bg1 })
call s:h("Title", { "fg": s:green })
call s:h("Visual", { "bg": s:bg3 })
call s:h("VisualNOS", { "bg": s:bg3 })
call s:h("WarningMsg", { "fg": s:red })
call s:h("WildMenu", { "fg": s:blue, "bg": s:bg2 })
