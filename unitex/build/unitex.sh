#!/bin/bash

set -u

./startLibraryAndJniDemo.sh ./PackageCassysFR.lingpkg script/standard.uniscript ./Corpus ./Result $1

lng="FR"

while getopts 'l:' flag; do
  case "${flag}" in
    l) lng="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

case "${lng}" in
  FR|fr|f) lngpkg="./PackageCassysFR.lingpkg" ;;
  EN|en|e) lngpkg="./PackageCassysEN.lingpkg" ;;
  *) echo "langue inconnue ${lng}"; exit 1 ;;
esac

script='script/standard.uniscript'
indir='/corpus/in'
outdir='corpus/out'
ncores=''

java -Djava.library.path=. UnitexPackageBatch $lngpkg $script $indir $outdir $ncores
