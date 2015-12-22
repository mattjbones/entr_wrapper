#!/bin/bash
attempted_install=0
has_program=0

check_for() {
    program=$1
    $program > /dev/null 2>&1
    if [ $? -ne 127 ]
    then
        #echo "found $program"
        has_program=1
    else
        echo "Not found $program"
        has_program=0
    fi
}

install_entr() {
    local UNAME_S=$(uname -s)
    if [ $attempted_install -eq 0 ]
    then
        local attempted_install=1
        if [ $UNAME_S == 'Linux' ]
        then
            echo "using apt / yum to install entr"
            check_for "yum"
            if [ $has_program -eq 1 ]
            then
                yum install -y entr
            else
                apt-get install -y entr
            fi
        elif [ $UNAME_S == 'Darwin' ]
        then
            echo "attempting to use brew to install entr"
            check_for "brew"
            if [ $has_program -eq 1 ]
            then
                brew install entr
            else
                echo "Please install brew and retry - http://brew.sh"
            fi
        else
            echo "Please install entr and add to your path"
        fi
    else
        echo "Unable to install entr, plese try manually"
        exit 1
    fi
}

start_watch() {
    check_for "entr"
    if [ $has_program -eq 1 ]
    then
        echo "Watching: $target_dir" 
        ls $target_dir | entr $command
    else
        echo "installing entr"
        install_entr
        start_watch
    fi
}

print_usage (){
    echo "Usage:

    $0 [Args..]

    Options:
        -c  Command
            What command should be run on change of target file
            e.g \"make coverage\"

        -d  Target dir(s)
            Which files should be watched
            e.g \"test/*c src/*.c\"

    Alternative usage:
        Set two environmental variables W_COMMAND and W_DIR
        e.g.    export W_COMMAND=\"make coverage\"
                export W_DIR=\"test/*.c src/*.c\"

    ">&2
}

target_dir="$W_DIR"
command="$W_COMMAND"

if [ "x$target_dir" == "x" -o "x$command" == "x" ]; then
    if [ $# -le 2 ]; then
        echo "Invalid number of args"
        print_usage
        exit 1
    fi

    while getopts "d:c:" opt; do
    case $opt in
            d)
                target_dir="$OPTARG"
                #echo "Using target dir $target_dir"
                ;;
            c)
                command="$OPTARG"
                #echo "Using command $command"
                ;;
            *)
                print_usage
                exit 1
                ;;
        esac
    done
    if [ "x$target_dir" == "x" -a "x$command" == "x" ]; then
        echo "Invalid options"
        print_usage
        exit 1
    fi
fi

start_watch



