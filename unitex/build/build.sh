#!/bin/bash

set -u

function die() {
  echo $1
  exit 1
}

unitexdir="../../tmp/4056"
demodir="../../tmp/rundemo"
lngfpkg="../../tmp/rundemo/PackageCassysFR.lingpkg"

while getopts 'u:d:f:' flag; do
  case "${flag}" in
    u) unitexdir="${OPTARG}" ;;
    d) demodir="${OPTARG}" ;;
    f) lngfpkg="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

if [ "${unitexdir}" = "" ]; then
  echo "Le repertoire du build unitex (option -u) est obligatoire."
  exit 1
fi

if [ "${demodir}" = "" ]; then
  die "Le repertoire du la demo unitex (option -d) est obligatoire."
fi

if [ "${lngfpkg}" = "" ]; then
  die "Le package linguistique pour le français (option -f) est obligatoire."
fi

if [ ! -f "${unitexdir}/mkUnitexLib.sh" ] ; then
  die "Le repertoire du build unitex n'est pas valide."
fi

if [ ! -f "${unitexdir}/libUnitexJni.so" ] ; then
  die "La librairie Unitex n'est pas construite."
  exit 1
fi

if [ ! -f "${demodir}/rundemo.sh" ] ; then
  die "Le repertoire de la demo unitex n'est pas valide."
fi

if [ ! -f "${demodir}/UnitexPackageBatch.class" ] ; then
  die "La demo Unitex n'est pas construite."
fi

if [ ! -f "${lngfpkg}" ] ; then
  die "Le package linguistique pour le français fourni en paramètre n'est pas valide."
fi

builddir=$(dirname $0)/builddir

[ -d $builddir ] || mkdir $builddir

rm -rf $builddir/*

cp $unitexdir/libUnitexJni.so $builddir
cp unitex.sh $builddir
chmod u+x $builddir/unitex.sh
cp -r $demodir/fr $builddir
cp $demodir/*.java $builddir # Juste pour info
cp $demodir/*.class $builddir
cp $lngfpkg $builddir
