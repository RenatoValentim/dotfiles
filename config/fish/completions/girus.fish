# Fish completions for girus (generated from zsh completions)
# Global flags
complete -c girus -n "__fish_use_subcommand" -s h -l help -d "Show help"
complete -c girus -n "__fish_use_subcommand" -s c -l config -d "Config file path"

# Top-level subcommands
complete -c girus -n "__fish_use_subcommand" -a "completion" -d "Generate autocompletion script"
complete -c girus -n "__fish_use_subcommand" -a "create" -d "Create resources"
complete -c girus -n "__fish_use_subcommand" -a "delete" -d "Delete resources"
complete -c girus -n "__fish_use_subcommand" -a "lab" -d "Manage labs"
complete -c girus -n "__fish_use_subcommand" -a "list" -d "List resources"
complete -c girus -n "__fish_use_subcommand" -a "repo" -d "Manage lab repositories"
complete -c girus -n "__fish_use_subcommand" -a "status" -d "Show current status"
complete -c girus -n "__fish_use_subcommand" -a "update" -d "Update GIRUS CLI"
complete -c girus -n "__fish_use_subcommand" -a "version" -d "Show version"
