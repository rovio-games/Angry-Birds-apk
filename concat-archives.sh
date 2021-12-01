if [[ $# -lt 2 ]]
then
    echo "Usage: \"$BASH_SOURCE\" <source_directory> <target_directory>" >&2
    echo "* <source_directory>: The source directory containing only sub-directories, each containing split archives for one single game" >&2
    echo "* <target_directory>: The target directory for all .apk or .xapk files" >&2

    exit 1
else
    srcDir="$1"
    targetDir="$2"
fi

DIRNAME="$(dirname "$(realpath "$BASH_SOURCE")")"

source "$DIRNAME/games.sh"

# Concatenate split archives into a .apk or .xapk file, using the "cat" program
# Usage: concat_archive "<source_directory>" "<target_directory>"
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

# concatenate all split archives
# Usage: concat_all "<split_archives_directory>" "<target_directory>"
function concat_all {
    local srcDir="$1" targetDir="$2"

    mkdir -p "$targetDir"

    for game in "${GAMES[@]}"
    do
        local splitDir="$srcDir/$game"
        concat_archive "$splitDir" "$targetDir" &
    done

    wait
}

concat_all "$srcDir" "$targetDir"