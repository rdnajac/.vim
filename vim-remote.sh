function vim-remote() {
    # Default values
    local protocol="scp"
    local host="aws"

    # Array for files
    local files=()

    # Parse options
    while getopts "p:h:" opt; do
        case $opt in
            p) protocol=$OPTARG ;;
            h) host=$OPTARG ;;
            \?) echo "Invalid option: -$OPTARG" >&2; return 1 ;;
        esac
    done

    # Shift off the options and optional arguments processed by getopts
    shift $((OPTIND-1))

    # Check remaining arguments for files
    if [ $# -eq 0 ]; then
        # Open the remote home directory if no files are specified
        vim "${protocol}://${host}/"
    else
        # Prepare files with complete URLs
        for file in "$@"; do
            files+=("${protocol}://${host}/${file}")
        done
        vim "${files[@]}"
    fi
}

# Reset OPTIND for the next time getopts is used in the shell environment
OPTIND=1

