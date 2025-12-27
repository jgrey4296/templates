## themes.nu -*- mode: Nushell -*-

export-env {
    print $"(ansi light_red)* Light Theme...(ansi reset)"

    mut light_theme = { colors: {} table: {} }

    $light_theme.colors = {
        # color for nushell primitives
        separator: dark_gray
        leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
        header: green_bold
        empty: blue
        row_index: green_bold
        record: white
        list: white
        block: white
        hints: dark_gray
    }

    # Primitives
    $light_theme.colors = $light_theme.colors | merge {
        int: dark_gray
        duration: dark_gray
        range: dark_gray
        float: dark_gray
        string: dark_gray
        nothing: dark_gray
        binary: dark_gray
        cellpath: dark_gray
        bool: {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
        filesize: { || match $in {
            $it if $it == 0b => 'white',
            $it if $it < 1mb => 'cyan',
            _ => 'blue'
        } }
        datetime : {|x|
            let now = (date now)
              match $x {
            $it if $it > $now  => "green",
            $it if $it > ($now - 1hr)  => 'red3b',
            $it if $it > ($now - 6hr)  => 'orange3',
            $it if $it > ($now - 1day) => 'yellow3b',
            $it if $it > ($now - 3day) => 'chartreuse2b',
            $it if $it > ($now - 1wk)  => 'green3b',
            $it if $it > ($now - 6wk)  => 'darkturquoise'
            $it if $it > ($now - 52wk) => 'deepskyblue3b'
            _                         => 'dark_gray'
        }}
    }

    # shapes
    $light_theme.colors = $light_theme.colors | merge {
        shape_and: purple_bold
        shape_binary: purple_bold
        shape_block: blue_bold
        shape_bool: light_cyan
        shape_custom: green
        shape_datetime: cyan_bold
        shape_directory: cyan
        shape_external: cyan
        shape_externalarg: green_bold
        shape_filepath: cyan
        shape_flag: blue_bold
        shape_float: purple_bold
        # shapes are used to change the cli syntax highlighting
        shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
        shape_globpattern: cyan_bold
        shape_int: purple_bold
        shape_internalcall: cyan_bold
        shape_list: cyan_bold
        shape_literal: blue
        shape_match_pattern: green
        shape_matching_brackets: { attr: u }
        shape_nothing: light_cyan
        shape_operator: yellow
        shape_or: purple_bold
        shape_pipe: purple_bold
        shape_range: yellow_bold
        shape_record: cyan_bold
        shape_redirection: purple_bold
        shape_signature: green_bold
        shape_string: green
        shape_string_interpolation: cyan_bold
        shape_table: blue_bold
        shape_variable: purple
    }

    # External completer example
    # let carapace_completer = {|spans|
    #     carapace $spans.0 nushell $spans | from json
    # }

    $env.themes               = ($env.themes? | default {} | merge { light: $light_theme })
    $env.config.color_config  = ($env.config.color_config? | default {} | merge $env.themes.light.colors)
    $env.config.table         = ($env.config.table? | default {} | merge $env.themes.light.table)

}
