## themes.nu -*- mode: Nushell -*-

export-env {
    print $"(ansi light_red)* Dark Theme...(ansi reset)"

    mut dark_theme = { colors: {} table: {} }

    $dark_theme.colors = {
        # color for nushell primitives
        separator                 : white
        leading_trailing_space_bg : { attr: n } # no fg, no bg, attr none effectively turns this off
        header                    : green_bold
        empty                     : blue
        row_index                 : green_bold
        record                    : white
        list                      : white
        block                     : white
        hints                     : dark_gray
        }

    # primitives
    $dark_theme.colors = $dark_theme.colors | merge {
        int: white
        range: white
        float: white
        string: white
        nothing: white
        binary: white
        cellpath: white
        duration: blue
        bool: {|| if $in { 'light_green' } else { "red" } }
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
            }
        }
        }

    # shapes
    $dark_theme.colors = $dark_theme.colors | merge {
        shape_and                   :  purple_bold
        shape_binary                :  purple_bold
        shape_block                 :  blue_bold
        shape_bool                  :  light_cyan
        shape_custom                :  green
        shape_datetime              :  cyan_bold
        shape_directory             :  cyan
        shape_external              :  cyan
        shape_externalarg           :  green_bold
        shape_filepath              :  cyan
        shape_flag                  :  blue_bold
        shape_float                 :  purple_bold
        shape_garbage               :  { fg: "#FFFFFF" bg: "#FF0000" attr: b}
        shape_globpattern           :  cyan_bold
        shape_int                   :  purple_bold
        shape_internalcall          :  cyan_bold
        shape_list                  :  cyan_bold
        shape_literal               :  blue
        shape_match_pattern         :  green
        shape_matching_brackets     :  { attr: u }
        shape_nothing               :  light_cyan
        shape_operator              :  yellow
        shape_or                    :  purple_bold
        shape_pipe                  :  purple_bold
        shape_range                 :  yellow_bold
        shape_record                :  cyan_bold
        shape_redirection           :  purple_bold
        shape_signature             :  green_bold
        shape_string                :  green
        shape_string_interpolation  :  cyan_bold
        shape_table                 :  blue_bold
        shape_variable :  purple
        }

    $dark_theme.table = $dark_theme.table | merge {
        mode : "rounded"
    }

    # External completer example
    # let carapace_completer = {|spans|
    #     carapace $spans.0 nushell $spans | from json
    # }

    $env.themes               = ($env.themes? | default {} | merge { dark: $dark_theme })
    $env.config.color_config  = ($env.config.color_config? | default {} | merge $env.themes.dark.colors)
    $env.config.table         = ($env.config.table? | default {} | merge $env.themes.dark.table)
}
