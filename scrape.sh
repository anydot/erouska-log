#!/bin/bash
set -eu

baseurl="https://storage.googleapis.com/exposure-notification-export-qhqcx"
datadir="erouska"

mkdir -p $datadir

curl "$baseurl/erouska/index.txt" | while read file; do
    outfile=$datadir/`basename $file`
    test -e $outfile || curl -o $outfile $baseurl/$file || rm -f $outfile
done
