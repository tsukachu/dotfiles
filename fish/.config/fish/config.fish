if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path ~/.emacs.d/bin

    # pyenv
    set -x PYENV_ROOT $HOME/.pyenv # configで都度読み込まれるので-U/--universalは外す
    test -d $PYENV_ROOT/bin; and fish_add_path $PYENV_ROOT/bin
    pyenv init - fish | source
    # pyenv-virtualenv
    pyenv virtualenv-init - | source
end

# Intel/Apple Siliconでパスが変わるので
set --local prefix (brew --prefix)

# homebrew
if type -q brew
    eval ("$prefix/bin/brew" shellenv)
end

# python推奨ビルド環境用
set -x PATH "$prefix/opt/sqlite/bin" "$prefix/opt/tcl-tk@8/bin" $PATH
set -x LDFLAGS "-L$prefix/opt/sqlite/lib -L$prefix/opt/tcl-tk@8/lib -L$prefix/opt/zlib/lib"
set -x CPPFLAGS "-I$prefix/opt/sqlite/include -I$prefix/opt/tcl-tk@8/include -I$prefix/opt/zlib/include"
set -x PKG_CONFIG_PATH "$prefix/opt/sqlite/lib/pkgconfig:$prefix/opt/tcl-tk@8/lib/pkgconfig:$prefix/opt/zlib/lib/pkgconfig"
