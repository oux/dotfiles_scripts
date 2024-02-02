#!/bin/bash

CP_NAME=$1

CLIP=$(xsel $CP_NAME)
case $BLOCK_BUTTON in
    3)
        echo -n "$CLIP" |strings | xsel -is
        echo -n "$CLIP" |strings | xsel -ip
        echo -n "$CLIP" |strings | xsel -ib
        ;;
esac
CLIP=$(xsel $CP_NAME |strings | sed "s/[\"']//g;q")
echo "${CLIP::20}"
