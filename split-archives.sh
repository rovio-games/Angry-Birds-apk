if [[ $# -lt 2 ]]
then
    echo "Usage: \"$BASH_SOURCE\" <source_directory> <target_directory>" >&2
    echo "* <source_directory>: The source directory containing all .apk or .xapk files" >&2
    echo "* <target_directory>: The target directory for split archives, will include several sub-directories, each containing the splits for a single game" >&2

    exit 1
else
    srcDir="$1"
    targetDir="$2"
fi

DIRNAME="$(dirname "$(realpath "$BASH_SOURCE")")"

source "$DIRNAME/games.sh"

GITHUB_FILE_SIZE_LIMIT=49000000 # < 50 MB
splitFlags="-d -a 2 -b $GITHUB_FILE_SIZE_LIMIT"

# Split an archive using the "split" program
# Usage: split_archive "<archive_path>" "<target_directory>"
function split_archive {
    local archivePath="$1" targetDir="$2"

    local prefix="$targetDir/$(basename "$archivePath")"

    mkdir -p "$targetDir"
    split $splitFlags "$archivePath" "$prefix"
}

function split_all {
    local srcDir="$1" targetDir="$2"

    declare -r OLD_IFS="$IFS"
    local IFS="$(echo -en "\n\b")"

    local archives=($(find "$srcDir" -regex ".*.x?apk"))

    IFS="$OLD_IFS"

    for archive in "${archives[@]}"
    do
        local game="$(basename "$archive")"
        game="${game%%_*}"

        local splitDir="$targetDir/$game"
        split_archive "$archive" "$splitDir" &
    done

    for archive in "${archives[@]}"
    do
        wait -fn
    done
}

split_all "$srcDir" "$targetDir"