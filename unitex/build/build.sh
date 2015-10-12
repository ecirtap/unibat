#!/bin/bash

set -u

function die() {
  echo $1
  exit 1
}

unitexdir="../../tmp/4068"
lngfpkg="../../tmp/lingpkg/PackageCassysFR.lingpkg"
lngepkg="../../tmp/lingpkg/PackageCassysEN.lingpkg"

while getopts 'u:d:f:e:' flag; do
  case "${flag}" in
    u) unitexdir="${OPTARG}" ;;
    f) lngfpkg="${OPTARG}" ;;
    e) lngepkg="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

if [ "${unitexdir}" = "" ]; then
  echo "Le repertoire du build unitex (option -u) est obligatoire."
  exit 1
fi

if [ "${lngfpkg}" = "" ]; then
  die "Le package linguistique pour le français (option -f) est obligatoire."
fi

if [ "${lngepkg}" = "" ]; then
  die "Le package linguistique pour l'anglais (option -e) est obligatoire."
fi

if [ ! -f "${unitexdir}/mkUnitexLib.sh" ] ; then
  die "Le repertoire du build unitex n'est pas valide."
fi

if [ ! -f "${unitexdir}/libUnitexJni.so" ] ; then
  die "La librairie Unitex n'est pas construite."
  exit 1
fi

if [ ! -f "${lngfpkg}" ] ; then
  die "Le package linguistique pour le français fourni en paramètre n'est pas valide."
fi

if [ ! -f "${lngepkg}" ] ; then
  die "Le package linguistique pour l'anglais fourni en paramètre n'est pas valide."
fi

builddir=$(dirname $0)/builddir

[ -d $builddir ] || mkdir $builddir

rm -rf $builddir/*

cp $unitexdir/libUnitexJni.so $builddir
cp $unitexdir/RunUnitexDynLib $builddir
cp $unitexdir/showversion.sh $builddir
cp unitex.sh $builddir
chmod u+x $builddir/unitex.sh
chmod u+x $builddir/showversion.sh
cp $lngfpkg $builddir
cp $lngepkg $builddir
cp /vagrant/tmp/rundemo/PackageCassysFR.lingpkg $builddir/PackageCassysFR_OK.lingpkg

docker build -t unitex --rm=true .
