# yargs completion script for opencode (fish).
status --is-interactive; or return
type -q opencode; or return

function __fish_opencode_yargs_completions
    set -l args
    if commandline -x >/dev/null 2>&1
        set args (commandline -xpc)
    else
        set args (commandline -opc)
    end

    opencode --get-yargs-completions $args (commandline -t) 2>/dev/null | while read -l line
        string escape -- $line
    end
end

complete -c opencode -f -a "(__fish_opencode_yargs_completions)"
