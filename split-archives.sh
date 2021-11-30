DIRNAME="$(dirname "$(realpath "$BASH_SOURCE")")"

source "$DIRNAME/dirs.sh"
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
    declare -r OLD_IFS="$IFS"
    local IFS="$(echo -en "\n\b")"

    local archives=($(find "$DIRNAME/$EXTRACTED_DIR" -regex ".*.x?apk"))

    IFS="$OLD_IFS"

    for i in $(seq 0 $(expr ${#archives[@]} - 1))
    do
        local archive="${archives[i]}"
        local game="$(basename "$archive")"
        game="${game%%_*}"

        split_archive "$archive" "$DIRNAME/$SPLIT_DIR/$game"
    done
}

split_all