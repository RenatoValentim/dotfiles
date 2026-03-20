# Enable CPAN local::lib if present
if test -d "$HOME/perl5"
    set -gx PERL_LOCAL_LIB_ROOT "$HOME/perl5"
    set -gx PERL_MB_OPT "--install_base $HOME/perl5"
    set -gx PERL_MM_OPT "INSTALL_BASE=$HOME/perl5"
    set -gx PATH "$HOME/perl5/bin" $PATH

    if command -v perl >/dev/null 2>&1
        set -l perl_arch (perl -MConfig -e 'print $Config{archname}')
        set -gx PERL5LIB "$HOME/perl5/lib/perl5" "$HOME/perl5/lib/perl5/$perl_arch" $PERL5LIB
    else
        set -gx PERL5LIB "$HOME/perl5/lib/perl5" $PERL5LIB
    end
end
