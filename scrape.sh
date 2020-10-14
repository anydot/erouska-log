#!/bin/bash
set -eu

baseurl="https://storage.googleapis.com/exposure-notification-export-qhqcx"
datadir="erouska"

mkdir -p $datadir

curl "$baseurl/erouska/index.txt" | while read file; do
    outfile=$datadir/`basename $file .zip`.json

    if [ ! -e $outfile ]; then
        tmp=`mktemp`
        curl $baseurl/$file > $tmp
        unzip -p $tmp "export.bin" | ./parser/exposure_to_json.py > $outfile 
        rm -f $tmp
    fi
done
