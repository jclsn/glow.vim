vim9script

def ErrorMsg(msg: string)
	echohl ErrorMsg | echomsg msg | echohl None
enddef

# Run Func once glow's output is completely in the terminal buffer. Vim copies
# the last screen into the buffer only after close_cb, hence the timer.
def AfterGlow(Func: func)
	timer_start(0, (_) => Func())
enddef

def CheckFiletypes(path: string): bool

	var extension = expand('%:e')	# Get the file extension

	if !empty(path)
		extension = fnamemodify(path, ':e')	# Get the file extension
	endif

	var allowed_filetypes = ["md", "markdown", "mkd", "mkdn", "mdwn", "mdown", "mdtxt", "mdtext", "rmd"]

	var ft_found = false
	for ft in allowed_filetypes
		if extension == ft
			ft_found = true
			break
		endif
	endfor

	if ft_found == false
		echohl WarningMsg
		echo 'Glow only supports markdown files'
		echohl None
		return false
	endif

	return true
enddef

def OpenGlow(mods: string, path: string)
	if !executable('glow')
		ErrorMsg('glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!')
		return
	endif

	if !CheckFiletypes(path)
		return
	endif

	const file: string = path ?? expand('%')

	if !file->fnamemodify(':p')->filereadable()
		ErrorMsg($'File not readable: {file}')
		return
	endif

	autocmd TerminalOpen * setlocal nolist
	autocmd TerminalOpen * highlight ExtraWhitespace NONE

	const ptybuf: number = term_start(['glow', file], {
		norestore: true,
		term_name: $'glow {file}',
		hidden: true,
		term_cols: 1000,
		term_finish: 'open',
		term_opencmd: $'{mods} buffer %d | normal! gg'
		})

	setbufvar(ptybuf, '&bufhidden', 'wipe')
enddef


def OpenGlowSplit(mods: string, path: string)
	if !executable('glow')
		ErrorMsg('glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!')
		return
	endif

	if !CheckFiletypes(path)
		return
	endif

	const file: string = path ?? expand('%')

	if !file->fnamemodify(':p')->filereadable()
		ErrorMsg($'File not readable: {file}')
		return
	endif

	autocmd TerminalOpen * setlocal nolist
	autocmd TerminalOpen * highlight ExtraWhitespace NONE

	const ptybuf: number = term_start(['glow', file], {
		norestore: true,
		term_name: $'glow {file}',
		hidden: true,
		term_cols: 1000,
		term_finish: 'open',
		term_opencmd: $'{mods} sbuffer %d | normal! gg'
		})

	setbufvar(ptybuf, '&bufhidden', 'wipe')
enddef

def ShowPopup(buf: number, file: string)
	const winid: number = popup_create(buf, {
		title: $' glow {file} ',
		hidden: false,
		border: [],
		borderchars: ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
		padding: [0, 1, 0, 1],
		minwidth: floor(&columns * 0.5)->float2nr(),
		maxwidth: floor(&columns * 0.8)->float2nr(),
		minheight: floor(&lines * 0.8)->float2nr(),
		maxheight: floor(&lines * 0.8)->float2nr(),
		})
	win_execute(winid, 'normal! gg')
enddef

def OpenGlowPop(mods: string, path: string)

	if !executable('glow')
		ErrorMsg('glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!')
		return
	endif

	if !CheckFiletypes(path)
		return
	endif

	const file: string = path ?? expand('%')

	if !file->fnamemodify(':p')->filereadable()
		ErrorMsg($'File not readable: {file}')
		return
	endif

	autocmd TerminalOpen * setlocal nolist
	autocmd TerminalOpen * highlight ExtraWhitespace NONE

	var ptybuf: number
	ptybuf = term_start(['glow', file], {
		norestore: true,
		term_name: $'glow {file}',
		hidden: true,
		term_highlight: 'Pmenu',
		close_cb: (_) => AfterGlow(() => ShowPopup(ptybuf, file))
		})

	setbufvar(ptybuf, '&bufhidden', 'delete')
enddef


command -nargs=? -complete=file Glow OpenGlow(<q-mods>, <q-args>)
command -nargs=? -complete=file Glowsplit OpenGlowSplit(<q-mods>, <q-args>)
command -nargs=? -complete=file Glowpop OpenGlowPop(<q-mods>, <q-args>)

