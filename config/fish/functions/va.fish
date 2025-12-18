# Python virtual environment activator
function va
    set -l ACTIVATE_FILE (find . -maxdepth 3 -type f -path "./*/bin/activate.fish" 2>/dev/null | head -n 1)

    if test -z "$ACTIVATE_FILE"
        set ACTIVATE_FILE (find . -maxdepth 3 -type f -path "./*/bin/activate" 2>/dev/null | head -n 1)
    end

    if test -n "$ACTIVATE_FILE"
        if string match -q "*.fish" "$ACTIVATE_FILE"
            source "$ACTIVATE_FILE"
            echo "🔵 Activate Environment: $ACTIVATE_FILE"
            echo "🔵 Python Path: $(command -v python)"
            echo "✅ Python Version: $(python --version 2>&1)"
        else
            echo "❌ Found non-fish activate script at $ACTIVATE_FILE; expected activate.fish"
            return 1
        end
    else
        echo "❌ Python Virtual Environment not found in $(pwd)"
    end
end
