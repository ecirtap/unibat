#!/bin/bash

set -u

nthread=2
indir=''
debug='m'
outdir=''

cmdpath=$(dirname $0)

export PATH=$cmdpath:$PATH

while getopts 's:t:i:o:vd:' flag; do
  case "${flag}" in
    s) sname="${OPTARG}" ;;
    t) nthread="${OPTARG}" ;;
    i) indir="${OPTARG}" ;;
    o) outdir="${OPTARG}" ;;
    d) debug="${OPTARG}" ;;
    v) showversion.sh; exit $? ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

lngpkg='./PackageCassys.lingpkg'

optdebug=''
case "${debug}" in
  m) optdebug='-m';;
  f) optdebug='-f';;
  *) echo "option de debug inconnue ${debug}"; exit 1 ;;
esac

if [ ! -d $indir ] ; then
  echo "Repertoire d'entree inexistant: $indir"; exit 1
fi

if [ ! -d $outdir ] ; then
  echo "Repertoire de sortie inexistant: $outdir"; exit 1
fi

cd $cmdpath

if [ "$sname" = "" ] ; then
  echo "le script n'est pas specifie"; exit 1
fi

script="script/$sname"

export LD_LIBRARY_PATH=$cmdpath
CMD="RunUnitexDynLib { BatchRunScript -o $outdir -i $indir -t $nthread $lngpkg -v -p $optdebug -s $script }"

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

