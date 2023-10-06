#!/bin/bash
ETAGS_PROG=etags
CTAGS_PROG=Ctags
TAGS_FILE=TAGS
DIRS=${1:-.}
ETAGS=true
CTAGS=true

function etags_yml() {
    $ETAGS_PROG $(find -name "*.yml" -o -name "*.yaml" -o -name "*.sh")
    awk 'BEGIN{print ""}
    BEGINFILE{print FILENAME",0"}
    /^[^ ]*:/{link = $1;gsub(":$","",link);print $0""link""FNR}
    ENDFILE{print ""}' $(find $DIRS -name "*.yml" ) >> $TAGS_FILE
}

function ctags_yml() {
    $CTAGS_PROG $(find -name "*.yml" -o -name "*.yaml" -o -name "*.sh")
    awk '/^[^ ]*:/{
        link = $1
        gsub(":$","",link)
        print link"\t"FILENAME"\t/^"$0"$/;\"\ta"}' $(find $DIRS -name "*.yml" ) >> $TAGS_FILE
    mv $TAGS_FILE $TAGS_FILE.unsorted
    sort $TAGS_FILE.unsorted > $TAGS_FILE
}

$ETAGS_PROG --list-features |grep -q yaml && etags_yml || ETAGS=false
$CTAGS_PROG --list-features |grep -q yaml && ctags_yml || CTAGS=false
$ETAGS || $CTAGS && exit 0
echo "Please install universal ctags with 'sudo apt install universal-ctags' to get yaml support"; exit 1;
