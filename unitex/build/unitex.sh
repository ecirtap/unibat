#!/bin/bash

set -u

lng=''
nthread=2
fmt=''
indir=''
optm='-m'
outdir=''

cmdpath=$(dirname $0)

export PATH=$cmdpath:$PATH

while getopts 'l:t:f:i:o:vd' flag; do
  case "${flag}" in
    l) lng="${OPTARG}" ;;
    f) fmt="${OPTARG}" ;;
    t) nthread="${OPTARG}" ;;
    i) indir="${OPTARG}" ;;
    o) outdir="${OPTARG}" ;;
    d) optm='' ;;
    v) showversion.sh; exit $? ;;
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
  echo "Repertoire d'entree inexistant: $indir"; exit 1
fi

if [ ! -d $outdir ] ; then
  echo "Repertoire de sortie inexistant: $outdir"; exit 1
fi

cd $cmdpath

script="script/${lng}_${fmt}.uniscript"

export LD_LIBRARY_PATH=$cmdpath
CMD="RunUnitexDynLib { BatchRunScript -o $outdir -i $indir -t $nthread $lngpkg -v -p $optm -s $script }"

echo "=================================="
echo "Commande: $CMD"
showversion.sh
echo "Version du package linguistique: " $(cat $cmdpath/lng_version)
echo "Version de GCC: " $(cat $cmdpath/gcc_version)
grep VERSION= /etc/os-release
echo "**********************************"
echo "Date d'execution debut: " $(date)
echo "**********************************"
$CMD
echo "**********************************"
echo "Date d'execution fin: " $(date)
echo "**********************************"

