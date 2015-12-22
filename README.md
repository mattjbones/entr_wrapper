# entr_wrapper
Little script that wraps "entr", the file watcher command runner. Inspired by grunt / watch but for use with other, non-js, projects.

This came about when I found myself working on some C code after I spent about a month working on a project using Grunt and grunt-contrib-watch to auto-build/test/coverage. 

## Usage
Best way to run is to add `W_COMMAND` and `W_DIR` environmental variables then run with `$ ./watch.sh`. 

However you can use command line args:

    ./watch.sh [Args..]

    Options:
        -c  Command
            What command should be run on change of target file
            e.g "make coverage"

        -d  Target dir(s)
            Which files should be watched
            e.g "test/*c src/*.c"

    Alternative usage:
        Set two environmental variables W_COMMAND and W_DIR
        e.g.    export W_COMMAND="make coverage"
                export W_DIR="test/*.c src/*.c"

