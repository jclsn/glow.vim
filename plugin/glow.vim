" Author        : Jan Claussen
" Created       : 09/03/2022
" License       : MIT
" Description   :

command Glow call OpenGlow()
command Glowsplit call OpenGlowSplit()

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
    let winid = 0
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

    if buf != 0
        call win_execute(buf, 'close')
    endif

    let buf = term_start( ['glow', filepath], #{hidden: 0,
                \                               vertical: 1,
                \                               term_rows: &lines,
                \ })

    " Close the terminal window

    let buffer_window = bufwinnr(buf)
    exe 'norm ' . buffer_window . "\<C-w>c"

    " Create a popup to display the terminal buffer in

        if winid != 0
            popup_close(winid)
        else

            let winid = popup_create( buf, #{hidden: 0,
                        \                    close: "button",
                        \                    minwidth: float2nr(floor(&columns * 0.5)),
                        \                    maxwidth: float2nr(floor(&columns * 0.8)),
                        \                    minheight: float2nr(floor(&lines * 0.8)),
                        \                    maxheight: float2nr(floor(&lines * 0.8))},
                        \  )

            let popup_window = bufwinnr(winid)

            " Add some options
            "
            call popup_setoptions( winid, #{title: ' ' . filename . ' '  ,
                        \		   border     : [1,1,1,1],
                        \		   padding    : [1,1,1,1],
                        \ })

            " Set the cursor position to 1. Needs to be set after the popup
            " has finished rendering somehow

            call cursor(1,1)
        endif

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
    let winid = 0
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

    if buf != 0
        call win_execute(buf, 'close')
    endif

    let buf = term_start( ['glow', filepath], #{hidden: 0,
                \                               vertical: 1,
                \                               term_rows: &lines,
                \ })

    call cursor(1,1)
endfunction
