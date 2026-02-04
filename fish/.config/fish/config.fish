if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path ~/.emacs.d/bin

    # pyenv
    set -x PYENV_ROOT $HOME/.pyenv # config で都度読み込まれるので-U/--universal は外す
    test -d $PYENV_ROOT/bin; and fish_add_path $PYENV_ROOT/bin
    pyenv init - fish | source
    # pyenv-virtualenv
    pyenv virtualenv-init - | source

    #nodenv
    set -x NODENV_ROOT $HOME/.nodenv # config で都度読み込まれるので-U/--universal は外す
    test -d $NODENV_ROOT/bin; and fish_add_path $NODENV_ROOT/bin
    nodenv init - fish | source
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
