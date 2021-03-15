#!/bin/bash
set -eu

baseurl="https://storage.googleapis.com/exposure-notification-export-qhqcx"
datadir="erouska"
uzisdir="uzis"

uzisSources=(
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/testy-pcr-antigenni.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/testy.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/kraj-okres-testy.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/nakaza.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/nakazeni-vyleceni-umrti-testy.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/zakladni-prehled.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/orp.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/obce.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/mestske-casti.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/hospitalizace.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovani.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovaci-mista.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/prehled-ockovacich-mist.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/prehled-odberovych-mist.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovani-spotreba.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovani-distribuce.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovani-registrace.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovani-rezervace.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/osoby.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/kraj-okres-nakazeni-vyleceni-umrti.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/vyleceni.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/umrti.json
    https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/pomucky.json
    )

mkdir -p $datadir $uzisdir

curl "$baseurl/erouska/index.txt" | while read file; do
    outfile=$datadir/`basename $file .zip`.json

    if [ ! -e $outfile ]; then
        tmp=`mktemp`
        curl $baseurl/$file > $tmp
        unzip -p $tmp "export.bin" | ./parser/exposure_to_json.py > $outfile 
        rm -f $tmp
    fi
done

## UZIS data

for uzisDataset in ${uzisSources[@]}; do
    curl $uzisDataset -o $uzisdir/`basename $uzisDataset`
done


