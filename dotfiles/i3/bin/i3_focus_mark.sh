#!/bin/bash

function _i3_mark_exists() {
    mark=$(i3-msg -t get_tree |jq -cM 'recurse(.nodes[]) |select(.mark=="'$1'")')
    [ -z "$mark" ] && return 1
    return 0
}

function _i3_is_focused_mark() {
    is_focused=$(i3-msg -t get_tree |jq -cM 'recurse(.nodes[]) |select(.mark=="'$1'") |.focused')
    [ -z '$is_focused' ] && return 1
    eval $is_focused
}

case $1 in
    -t|--toggle)
        shift
        if _i3_mark_exists $1
        then
            if _i3_is_focused_mark $1
            then
                i3-msg -q '[con_mark="^_prev_'$1'$"] focus'
            else
                i3-msg -q mark _prev_$1
                i3-msg -q '[con_mark="^'$1'$"] focus'
            fi
        else
            i3-msg -q mark $1
        fi
        ;;
    *)
        if _i3_mark_exists $1
        then
            i3-msg -q '[con_mark="^'$1'$"] focus'
        else
            i3-msg -q mark $1
        fi
        ;;
esac
