if status is-interactive
    # Commands to run in interactive sessions can go here

    # Doom Emacs
    fish_add_path ~/.emacs.d/bin

    # uv
    fish_add_path ~/.local/bin
end

if type -q brew
    # Homebrew 関連パスの起点を保持
    set --local prefix (brew --prefix)

    eval ("$prefix/bin/brew" shellenv)

    # Depends on Doom Emacs
    if test -d $prefix/opt/coreutils/libexec/gnubin
        fish_add_path $prefix/opt/coreutils/libexec/gnubin
    end
end
