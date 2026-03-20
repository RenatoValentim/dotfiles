# Add Ruby user gem bin to PATH
if command -v ruby >/dev/null 2>&1
    set -l ruby_user_dir (ruby -e 'print Gem.user_dir')
    if test -n "$ruby_user_dir"
        set -gx PATH "$ruby_user_dir/bin" $PATH
    end
end
