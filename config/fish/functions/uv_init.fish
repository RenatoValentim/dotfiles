# Initialize Python environment with UV
function uv_init
    if test -z "$argv"
        echo "❌ Erro: Python version not specified."
        echo "Use: uv_init <python-version>"
        return 1
    end
    
    echo "🔵 Initializing Python $argv[1] environment..."
    
    if uv init --bare --python=$argv[1] && \
       uv python pin $argv[1] && \
       mise use python@$argv[1]
        echo "✅ Environment setup completed successfully!"
        echo "⬜ Running 'uv venv'..."
    else
        echo "❌ Setup failed"
        return 1
    end
end
