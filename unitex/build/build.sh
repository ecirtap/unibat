#!/bin/bash

set -u

function die() {
  echo $1
  exit 1
}

unitexdir=""
lngpkg=""

while getopts 'u:l:' flag; do
  case "${flag}" in
    u) unitexdir="${OPTARG}" ;;
    l) lngpkg="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

if [ "${unitexdir}" = "" ]; then
  echo "Le repertoire du build unitex (option -u) est obligatoire."
  exit 1
fi

if [ "${lngpkg}" = "" ]; then
  die "Le package linguistique (option -l) est obligatoire."
fi

if [ ! -f "${unitexdir}/mkUnitexLib.sh" ] ; then
  die "Le repertoire du build unitex n'est pas valide."
fi

if [ ! -f "${unitexdir}/libUnitexJni.so" ] ; then
  die "La librairie Unitex n'est pas construite."
  exit 1
fi

if [ ! -f "${lngpkg}" ] ; then
  die "Le package linguistique fourni en paramètre n'est pas valide."
fi

LNG_VERSION=$(zipinfo -1 $lngpkg |grep resource/VERSION|sed -e s';resource/VERSION_;;')

echo "------------------------------"
echo "Construction de l'image Docker"
echo "------------------------------"
echo "unitexdir=${unitexdir}"
echo "lngpkg=${lngpkg}"
echo "------------------------------"
echo ""

builddir=$(dirname $0)/builddir

[ -d $builddir ] || mkdir $builddir

rm -rf $builddir/*

cp $unitexdir/libUnitexJni.so $builddir
cp $unitexdir/RunUnitexDynLib $builddir
cp $unitexdir/showversion.sh $builddir
cp unitex.sh $builddir
chmod u+x $builddir/unitex.sh
chmod u+x $builddir/showversion.sh
cp $lngpkg $builddir
echo $LNG_VERSION > "$builddir/lng_version"

docker build -t unitex --rm=true .
