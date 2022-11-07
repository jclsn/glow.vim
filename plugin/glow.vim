" Author        : Jan Claussen
" Created       : 09/03/2022
" License       : MIT
" Description   :

command Glow call OpenGlow()
command Glowsplit call OpenGlowSplit()

function! OpenGlow()

	let glowFound = executable('glow')
	if glowFound[5:13] == 'not found'
		echohl WarningMsg
		echo 'glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!'
		echohl None
		return
	endif

	let filepath = @%				" Get the file path
	let filename = expand('%:t')    " Get the file name
	let extension = expand('%:e')	" Get the file extension
	let popup_id = 0
	let buf = 0

	" Display a warning message if the current file is not of type markdown

	let allowed_filetypes = ["md", "markdown", "mkd", "mkdn", "mdwn", "mdown", "mdtxt", "mdtext", "rmd"]

	let ft_found = 0
	for ft in allowed_filetypes
		if extension == ft
			let ft_found = 1
			break
		endif
	endfor

	if ft_found == 0
		echohl WarningMsg
		echo 'Glow only supports markdown files'
		echohl None
		return
	endif


	" Open a hidden terminal buffer an run glow in it

	let buf = term_start( ['glow', filepath], #{hidden: 1,
				\                               vertical: 1,
				\                               term_rows: &lines,
				\ })

	" Create a popup to display the terminal buffer in

	if popup_id != 0
		popup_close(popup_id)
	else

		let popup_id = popup_create( buf, #{hidden: 0,
					\                    close: "button",
					\                    minwidth: float2nr(floor(&columns * 0.5)),
					\                    maxwidth: float2nr(floor(&columns * 0.8)),
					\                    minheight: float2nr(floor(&lines * 0.8)),
					\                    maxheight: float2nr(floor(&lines * 0.8))},
					\  )

		let popup_window = bufwinnr(popup_id)

		" Add some options
		"
		call popup_setoptions( popup_id, #{title: ' ' . filename . ' '  ,
					\		   border     : [1,1,1,1],
					\		   padding    : [1,1,1,1],
					\ })

		" Set the cursor position to 1. Needs to be set after the popup
		" has finished rendering somehow

	endif

	call win_execute(popup_id, "call cursor(1, 1)")

	return

endfunction


function! OpenGlowSplit()

	let glowFound = system('which glow')
	if glowFound[5:13] == 'not found'
		echohl WarningMsg
		echo 'glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!'
		echohl None
		return
	endif

	let filepath = @%				" Get the file path
	let filename = expand('%:t')    " Get the file name
	let extension = expand('%:e')	" Get the file extension
	let buf = 0

	" Display a warning message if the current file is not of type markdown

	let allowed_filetypes = ["md", "markdown", "mkd", "mkdn", "mdwn", "mdown", "mdtxt", "mdtext", "rmd"]

	for ft in $allowed_filetypes
		if extension != $ft
			echohl WarningMsg
			echo 'Glow only supports markdown files'
			echohl None
			return
		endif
	endfor


	" Open a hidden terminal buffer an run glow in it

	if bufexists(bufnr)
	endif

	let bufnr = term_start( ['glow', filepath], #{hidden: 0,
				\                               vertical: 1,
				\                               term_rows: &lines,
				\ })

endfunction
