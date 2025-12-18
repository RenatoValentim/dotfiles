# PostgreSQL connection inside container
function psqldocker
    if test (count $argv) -ne 3
        echo "❌ Error: Missing required parameters."
        echo "Usage: psqldocker <container> <user> <database>"
        return 1
    end
    
    echo "🔵 Connecting to PostgreSQL..."
    
    if docker exec -it "$argv[1]" psql -U "$argv[2]" -d "$argv[3]"
        echo "✅ Connection successful!"
    else
        echo "❌ Connection failed"
        return 1
    end
end
