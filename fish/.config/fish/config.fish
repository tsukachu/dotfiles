if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path ~/.emacs.d/bin

    # pyenv
    set -x PYENV_ROOT $HOME/.pyenv # config で都度読み込まれるので-U/--universal は外す
    test -d $PYENV_ROOT/bin; and fish_add_path $PYENV_ROOT/bin

    ## 遅延ロード
    function __pyenv_load
        if set -q __pyenv_loaded
            return
        end

        set -g __pyenv_loaded true

        pyenv init - fish | source
        pyenv virtualenv-init - | source
    end

    ## 関連するコマンドを遅延ロードの対象にする
    ## FIXME: DRY
    function pyenv
        functions -e pyenv
        __pyenv_load
        command pyenv $argv
    end
    function python
        functions -e python
        __pyenv_load
        command python $argv
    end
    function pip
        functions -e pip
        __pyenv_load
        command pip $argv
    end

    #nodenv
    set -x NODENV_ROOT $HOME/.nodenv # config で都度読み込まれるので-U/--universal は外す
    test -d $NODENV_ROOT/bin; and fish_add_path $NODENV_ROOT/bin

    ## 遅延ロード
    function __nodenv_load
        if set -q __nodenv_loaded
            return
        end

        set -g __nodenv_loaded true

        nodenv init - fish | source
    end

    ## 関連するコマンドを遅延ロードの対象にする
    ## FIXME: DRY
    function nodenv
        functions -e nodenv
        __nodenv_load
        command nodenv $argv
    end
    function node
        functions -e node
        __nodenv_load
        command node $argv
    end
    function npm
        functions -e npm
        __nodenv_load
        command npm $argv
    end

    function make
        functions -e make
        __pyenv_load
        __nodenv_load
        command make $argv
    end
end

# Intel/Apple Silicon でパスが変わるので
set --local prefix (brew --prefix)

# homebrew
if type -q brew
    eval ("$prefix/bin/brew" shellenv)
end

# python の推奨ビルド環境
set -x PATH "$prefix/opt/sqlite/bin" "$prefix/opt/tcl-tk@8/bin" $PATH
set -x LDFLAGS "-L$prefix/opt/sqlite/lib -L$prefix/opt/tcl-tk@8/lib -L$prefix/opt/zlib/lib"
set -x CPPFLAGS "-I$prefix/opt/sqlite/include -I$prefix/opt/tcl-tk@8/include -I$prefix/opt/zlib/include"
set -x PKG_CONFIG_PATH "$prefix/opt/sqlite/lib/pkgconfig:$prefix/opt/tcl-tk@8/lib/pkgconfig:$prefix/opt/zlib/lib/pkgconfig"
