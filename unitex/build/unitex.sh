#!/bin/bash

set -u

lng=''
nthread=2
fmt=''
indir=''
optm='-m'
outdir=''

while getopts 'l:t:f:i:o:vVd' flag; do
  case "${flag}" in
    l) lng="${OPTARG}" ;;
    f) fmt="${OPTARG}" ;;
    t) nthread="${OPTARG}" ;;
    i) indir="${OPTARG}" ;;
    o) outdir="${OPTARG}" ;;
    d) optm='' ;;
    V) $(dirname $0)/showversion.sh; ;;
    v) $(dirname $0)/showversion.sh; exit $? ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

lngpkg='./PackageCassys.lingpkg'

case "${lng}" in
  FR|fr|fra|f) lng='fra';;
  EN|en|eng|e) lng='eng';;
  *) echo "langue inconnue ${lng}"; exit 1 ;;
esac

case "${fmt}" in
  tei|xml) ;; 
  *) echo "format inconnu ${fmt}"; exit 1 ;;
esac

if [ ! -d $indir ] ; then
  echo "Repertoire d'entree inexistant: $indir"
fi

if [ ! -d $outdir ] ; then
  echo "Repertoire de sortie inexistant: $outdir"
fi

cd /soft

script="script/${lng}_${fmt}.uniscript"

export LD_LIBRARY_PATH=.
set -x
./RunUnitexDynLib { BatchRunScript -o $outdir -i $indir -t $nthread $lngpkg -v -p $optm -s $script }
