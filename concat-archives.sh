DIRNAME="$(dirname "$(realpath "$BASH_SOURCE")")"

source "$DIRNAME/dirs.sh"
source "$DIRNAME/games.sh"

# Concatenate split archives into a .apk or .xapk file, using the "cat" program
# Usage: split_archive "<source_directory>" "<target_directory>"
# Note: Source directory must only consist of split archives of the original archive, with suffixes 00, 01, 02, ...
function concat_archive {
    local srcDir="$1" targetDir="$2"

    declare -r OLD_IFS="$IFS"
    local IFS="$(echo -en "\n\b")"

    local srcFiles=($(find "$srcDir" -regex '^.*\.x?apk[0-9]+$' | sort))
    local targetFile="$(basename -a ${srcFiles[@]} | sed -Ee 's/(.*\.x?apk).{2}/\1/' | uniq)"

    cat ${srcFiles[@]} > "$targetDir/$targetFile"

    IFS="$OLD_IFS"
}

function concat_all {
    local targetDir="$DIRNAME/$EXTRACTED_DIR"
    mkdir -p "$targetDir"

    for game in "${GAMES[@]}"
    do
        local srcDir="$DIRNAME/$SPLIT_DIR/$game"
        concat_archive "$srcDir" "$targetDir" &
    done

    for game in "${GAMES[@]}"
    do
        wait -fn
    done
}

concat_all