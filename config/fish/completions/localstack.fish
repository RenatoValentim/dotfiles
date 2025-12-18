# Fish completions for localstack (generated from zsh completions)
# Global flags
complete -c localstack -n "__fish_use_subcommand" -s v -l version -d "Show version"
complete -c localstack -n "__fish_use_subcommand" -s d -l debug -d "Enable debug mode"
complete -c localstack -n "__fish_use_subcommand" -s p -l profile -d "Set configuration profile"
complete -c localstack -n "__fish_use_subcommand" -s h -l help -d "Show help"

# Main commands
complete -c localstack -n "__fish_use_subcommand" -a "auth" -d "Authenticate with LocalStack account"
complete -c localstack -n "__fish_use_subcommand" -a "completion" -d "CLI shell completion"
complete -c localstack -n "__fish_use_subcommand" -a "config" -d "Manage LocalStack config"
complete -c localstack -n "__fish_use_subcommand" -a "logs" -d "Show LocalStack logs"
complete -c localstack -n "__fish_use_subcommand" -a "restart" -d "Restart LocalStack"
complete -c localstack -n "__fish_use_subcommand" -a "ssh" -d "Obtain shell in LocalStack"
complete -c localstack -n "__fish_use_subcommand" -a "start" -d "Start LocalStack"
complete -c localstack -n "__fish_use_subcommand" -a "status" -d "Query status info"
complete -c localstack -n "__fish_use_subcommand" -a "stop" -d "Stop LocalStack"
complete -c localstack -n "__fish_use_subcommand" -a "update" -d "Update LocalStack"
complete -c localstack -n "__fish_use_subcommand" -a "wait" -d "Wait for LocalStack"

# Advanced commands
complete -c localstack -n "__fish_use_subcommand" -a "aws" -d "Access AWS Services"
complete -c localstack -n "__fish_use_subcommand" -a "dns" -d "Manage DNS host config"
complete -c localstack -n "__fish_use_subcommand" -a "ephemeral" -d "(Preview) Manage ephemeral instances"
complete -c localstack -n "__fish_use_subcommand" -a "extensions" -d "(Preview) Manage extensions"
complete -c localstack -n "__fish_use_subcommand" -a "license" -d "(Preview) Manage license"
complete -c localstack -n "__fish_use_subcommand" -a "pod" -d "Manage Cloud Pods"
complete -c localstack -n "__fish_use_subcommand" -a "replicator" -d "(Preview) Manage replication"
complete -c localstack -n "__fish_use_subcommand" -a "state" -d "(Preview) Export/restore state"
