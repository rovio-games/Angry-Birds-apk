githubFileSizeLimit=49000000 # < 50 MB
splitFlags="-d -a 2 -b $githubFileSizeLimit"

# Usage: split_archive "<archive_path>" "<target_directory>"
function split_archive {
    local archivePath="$1" targetDir="$2"

    local prefix="$targetDir/$(basename "$archivePath")"
    
    mkdir -p "$targetDir"
    split $splitFlags "$archivePath" "$prefix"
}
