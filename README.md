# Angry Birds APK
APK for Angry Birds games that are no longer updated and no longer found in Google Play.
* Angry Birds Classic
* Angry Birds Seasons
* Angry Birds Rio
* Angry Birds Space

# How to use

## Concatenating split archives
Because of GitHub's file size limits, the .apk or .xapk files are split into 49MB blocks before being uploaded to the repository. They are stored in the `split-archives` directory.

Run
```shell
make
```
to concatenate the .apk or .xapk files for each game. The concatenated files will be put in the `full-archives` directory.

## Split
Run
```shell
make split
```
command to split the original .apk or .xapk files into 49MB blocks. The results are placed in the sub-directories of the `split-archives` directory, each sub-directory corresponds to one single game.

## Clean up
Run
```shell
make clean
```
to clean up the generated .apk files in the `full-archives` directory.