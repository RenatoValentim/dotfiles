# Loaded in every context; the guard keeps it inert on the host.
if test -f /.dockerenv -o -f /run/.containerenv
    fish_add_path "$HOME/.local/bin"
end
