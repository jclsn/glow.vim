" Author        : Jan Claussen
" Created       : 09/03/2022
" License       : MIT
" Description   :

command Glow call OpenGlow()

function! OpenGlow()

    let filepath = @%				" Get the file path
    let filename = expand('%:t')    " Get the file name
	let extension = expand('%:e')	" Get the file extension


	" Display a warning message if the current file is not of type .md

	if extension != 'md'
		echohl WarningMsg
		echo 'Glow only supports markdown files'
		echohl None
		return
	endif


	" Open a hidden terminal buffer an run glow in it

	let buf = term_start( ['glow', filepath], #{hidden: 1} )


	" Create a popup to display the terminal buffer in

	let winid = popup_create( buf, #{hidden: 1, minwidth: 120, minheight: 70} )


	" Add some options

	call popup_setoptions( winid, #{title: ' ' . filename . ' '  ,
				\		   border     : [1,1,1,1],
				\		   padding    : [1,1,1,1],
				\		   cursorline : 0}
				\ )


	" Show the popup

	call popup_show(winid)

endfunction

