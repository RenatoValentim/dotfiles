function rm --description "Always prompt before removing"
    set -l new_args
    set -l inserted 0

    for arg in $argv
        if test $inserted -eq 0; and test "$arg" = --
            set new_args $new_args -i --
            set inserted 1
        else
            set new_args $new_args $arg
        end
    end

    if test $inserted -eq 0
        set new_args $new_args -i
    end

    command rm $new_args
end
