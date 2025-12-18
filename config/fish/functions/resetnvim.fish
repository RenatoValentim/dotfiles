# Reset Neovim configuration
function resetnvim
    rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
    echo "✅ Neovim reset completed"
end
