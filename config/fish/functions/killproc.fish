# Kill process by name
function killproc
    if test -z "$argv"
        echo "❌ Erro: Process name not specified."
        echo "Use: killproc <process_name>"
        return 1
    end

    echo "🔵 Trying to end '$argv[1]' process..."
    kill (ps aux | grep -i "$argv[1]" | grep -v grep | awk '{print $2}')

    sleep 2

    if ps aux | grep -i "$argv[1]" | grep -v grep &>/dev/null
        echo "🔵 '$argv[1]' still in execution. Forcing termination..."
        kill -9 (ps aux | grep -i "$argv[1]" | grep -v grep | awk '{print $2}')
    else
        echo "✅ '$argv[1]' successfully ended."
    end
end
