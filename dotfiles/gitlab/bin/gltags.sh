#!/bin/bash
DIRS="${@:-.}"

function exec_exists() {
    return $(which $1 &>/dev/null)
}

function etags_yml() {
    echo "building etags"
    proc=$1
    TAGS_FILE=TAGS
    $proc $(find $DIRS -name "*.yml" -o -name "*.yaml" -o -name "*.sh")
    awk 'BEGIN{print ""}
    BEGINFILE{print FILENAME",0"}
    /^[^ ]*:/{link = $1;gsub(":$","",link);print $0""link""FNR}
    ENDFILE{print ""}' $(find $DIRS -name "*.yml" -o -name "*.yaml" ) >> $TAGS_FILE
}

function ctags_yml() {
    echo "building ctags"
    proc=$1
    TAGS_FILE=tags
    $proc --append=no $(find $DIRS -name "*.yml" -o -name "*.yaml" -o -name "*.sh")
    awk '/^[^ ]*:/{
        link = $1
        gsub(":$","",link)
        print link"\t"FILENAME"\t/^"$0"$/;\"\ta"}' $(find $DIRS -name "*.yml" -o -name "*.yaml" ) >> $TAGS_FILE
    mv $TAGS_FILE $TAGS_FILE.unsorted
    sort $TAGS_FILE.unsorted > $TAGS_FILE
}

for proc in etags ctags
do
    [ $proc == "etags" ] && format=etags || format=ctags
    exec_exists $proc && $proc --list-languages |grep -q Yaml && ${format}_yml $proc && exit 0
done
echo "Please install universal ctags with 'sudo apt install universal-ctags' to get yaml support"
exit 1
