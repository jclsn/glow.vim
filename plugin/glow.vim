vim9script

def ErrorMsg(msg: string)
    echohl ErrorMsg | echomsg msg | echohl None
enddef

def PlaceCursor(job_status: job, exit_status: number)
	sleep 100m
	cursor(1, 1)
enddef

def OpenGlow(path: string)

    if !executable('glow')
        ErrorMsg('glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!')
        return
    endif

    const file: string = path ?? expand('%')

    if !file->fnamemodify(':p')->filereadable()
        ErrorMsg($'File not readable: {file}')
        return
    endif

    const ptybuf: number = term_start(['glow', file], {
        norestore: true,
        term_name: $'glow {file}',
        hidden: true,
        term_cols: 1000,
        term_highlight: 'Pmenu',
		exit_cb: PlaceCursor,
    })

    setbufvar(ptybuf, '&bufhidden', 'delete')

    const popup_id: number = popup_create(ptybuf, {
        title: $' glow {file} ',
		hidden: true,
        border: [],
        padding: [0, 1, 0, 1],
        minwidth: floor(&columns * 0.5)->float2nr(),
        maxwidth: floor(&columns * 0.8)->float2nr(),
        minheight: floor(&lines * 0.8)->float2nr(),
        maxheight: floor(&lines * 0.8)->float2nr(),
    })


	# Wait until the PlaceCursor function is finished here. But how?
	#
	popup_show(popup_id)

enddef

def OpenGlowSplit(mods: string, path: string)
    if !executable('glow')
        ErrorMsg('glow is not installed. Please visit https://github.com/charmbracelet/glow and follow the instructions!')
        return
    endif

    const file: string = path ?? expand('%')

    if !file->fnamemodify(':p')->filereadable()
        ErrorMsg($'File not readable: {file}')
        return
    endif

    # https://github.com/vim/vim/issues/8822#issuecomment-908670168
    const ptybuf: number = term_start(['glow', file], {
        norestore: true,
        term_name: $'glow {file}',
        hidden: true,
        term_cols: 1000,
        term_finish: 'open',
        term_opencmd: $'{mods} sbuffer %d'
    })

    setbufvar(ptybuf, '&bufhidden', 'wipe')
enddef

command -nargs=? -complete=file Glow OpenGlow(<q-args>)
command -nargs=? -complete=file GlowSplit OpenGlowSplit(<q-mods>, <q-args>)

