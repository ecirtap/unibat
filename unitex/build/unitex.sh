#!/bin/bash

set -u

lng="FR"
nthread='2'

while getopts 'l:t:' flag; do
  case "${flag}" in
    l) lng="${OPTARG}" ;;
    t) nthread="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

script='script/standard.uniscript'

case "${lng}" in
  FR|fr|f) lngpkg='./PackageCassysFR.lingpkg'
           script='script/french_tei.uniscript' ;;
  EN|en|e) lngpkg='./PackageCassysEN.lingpkg'
           script='script/english_tei.uniscript' ;;
  IT|it|i) lngpkg='./PackageCassysFR_OK.lingpkg'
           script='script/standard.uniscript' ;;
  *) echo "langue inconnue ${lng}"; exit 1 ;;
esac

indir='/corpus/in'
outdir='/corpus/out'

cd /soft
ls -l

export LD_LIBRARY_PATH=.
set -x
./RunUnitexDynLib { BatchRunScript -o $outdir -i $indir -t $nthread $lngpkg -v -p -m -s $script }
