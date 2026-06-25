function doom --description 'Run Doom with bundled Emacs LIBRARY_PATH (macOS cask)'
    set -l real ~/.emacs.d/bin/doom

    if test (uname) != Darwin
        $real $argv
        return
    end

    set -l plist /Applications/Emacs.app/Contents/Info.plist
    set -l libpath (/usr/bin/plutil -extract LSEnvironment.LIBRARY_PATH raw $plist 2>/dev/null)

    if test -z "$libpath"
        $real $argv
        return
    end

    if set -q LIBRARY_PATH
        set libpath "$libpath:$LIBRARY_PATH"
    end

    env LIBRARY_PATH=$libpath $real $argv
end
