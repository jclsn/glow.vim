" Author        : Jan Claussen
" Created       : 09/03/2022
" License       : MIT
" Description   :

command Glow call OpenGlow()

function! OpenGlow()
	let extension = expand('%:e')

	if extension != 'md'
		echohl WarningMsg
		echo 'Glow only supports markdown files'
		echohl None
		return
	endif
    let filepath = @%
    let filename = expand('%:t')
	let buf = term_start(['glow', filepath], #{hidden: 1})
	let winid = popup_create(buf, #{hidden: 1, minwidth: 120, minheight: 70})

	call popup_setoptions(winid, #{title: ' ' . filename . ' '  ,
				\		  border: [1,1,1,1],
				\		  padding: [1,1,1,1],
				\		  cursorline: 0}
				\		  )

	call popup_show(winid)
endfunction

