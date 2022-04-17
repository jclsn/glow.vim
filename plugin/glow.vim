" Author        : Jan Claussen
" Created       : 09/03/2022
" License       : MIT
" Description   :

command Glow call OpenGlow()

function! OpenGlow()

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


    " Display a warning message if the current file is not of type .md

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

    let buf = term_start( ['glow', filepath], #{hidden: 1}  )


    " Create a popup to display the terminal buffer in

    let winid = popup_create( buf, #{hidden: 0, minwidth: float2nr(floor(&columns * 0.5)), maxwidth: float2nr(floor(&columns * 0.8)), minheight: float2nr(floor(&lines * 0.8)), maxheight: float2nr(floor(&lines * 0.8))} )


    " Add some options

    call popup_setoptions( winid, #{title: ' ' . filename . ' '  ,
                \		   border     : [1,1,1,1],
                \		   padding    : [1,1,1,1],
                \		   cursorline : 0}
                \ )

    " Show the popup

    call cursor(1,1)

endfunction


