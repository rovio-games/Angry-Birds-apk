DIRNAME="$(dirname "$(realpath "$BASH_SOURCE")")"

source "$DIRNAME/dirs.sh"
source "$DIRNAME/games.sh"

githubFileSizeLimit=49000000 # < 50 MB
splitFlags="-d -a 2 -b $githubFileSizeLimit"

# Usage: split_archive "<archive_path>" "<target_directory>"
function split_archive {
    local archivePath="$1" targetDir="$2"

    local prefix="$targetDir/$(basename "$archivePath")"

    mkdir -p "$targetDir"
    split $splitFlags "$archivePath" "$prefix"
}

function split_all {
    for i in $(seq 0 $(expr ${#GAMES[@]} - 1))
    do
        local game="${GAMES[i]}"
        local apkFile="$(find "$DIRNAME/$EXTRACTED_DIR" -name "$game*.apk" | head -n 1)"
        local targetDir="$DIRNAME/$SPLIT_DIR/$game"

        split_archive "$apkFile" "$targetDir"
    done
}

split_all