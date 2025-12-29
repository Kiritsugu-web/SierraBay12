#!/bin/bash

set -o pipefail

dmepath=""
retval=1

for var; do
    if [[ $var != -* && $var == *.dme ]]; then
        dmepath=$(echo $var | sed -r 's/.{4}$//')
        break
    fi
done

if [[ $dmepath == "" ]]; then
    echo "No .dme file specified, aborting."
    exit 1
fi

# Use a temporary .dme file because BYOND compiler treats non-.dme files differently
# specifically affecting how it loads interface (.dmf) files.
build_dme="${dmepath}_build.dme"

if [[ -a $build_dme ]]; then
    rm $build_dme
fi

# Ensure we use the correct line endings (CRLF) for the modified DME if the original was CRLF
# but honestly, Linux DM supports LF just fine as long as the extension is .dme
cp $dmepath.dme $build_dme

for var; do
    arg=$(echo $var | sed -r 's/^.{2}//')
    if [[ $var == -D* ]]; then
        sed -i "1s!^!#define $arg\n!" $build_dme
    elif [[ $var == -I* ]]; then
        sed -i "s!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include \"$arg\"!" $build_dme
    elif [[ $var == -M* ]]; then
        sed -i "1s!^!#define MAP_OVERRIDE\n!" $build_dme
        sed -i "s!#include \"maps\\\\_map_include.dm\"!#include \"maps\\\\$arg\\\\$arg.dm\"!" $build_dme
    fi
done

source "$( dirname "${BASH_SOURCE[0]}" )/sourcedm.sh"

if [[ $DM == "" ]]; then
    echo "Couldn't find the DreamMaker executable, aborting."
    exit 3
fi

"$DM" $build_dme | tee build_log.txt
retval=$?

[[ -e ${dmepath}_build.dmb ]] && mv ${dmepath}_build.dmb $dmepath.dmb
[[ -e ${dmepath}_build.rsc ]] && mv ${dmepath}_build.rsc $dmepath.rsc

rm $build_dme

exit $retval
