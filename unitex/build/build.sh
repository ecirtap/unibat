#!/bin/bash

set -u

function die() { 
  echo $1; exit 1 
}

lngpkg=""
docker_compiled_image=""

while getopts 'i:l:' flag; do
  case "${flag}" in
    i) docker_compiled_image="${OPTARG}" ;;
    l) lngpkg="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

if [ "${docker_compiled_image}" = "" ]; then
  die "L'image docker qui a servi à construire Unitex (option -i) est obligatoire."
fi

iid=$(docker images -q $docker_compiled_image)
if [ "$iid" = "" ] ; then
  die "L'image ${docker_compiled_image} n'existe pas."
fi

if [ "${lngpkg}" = "" ]; then
  die "Le package linguistique (option -l) est obligatoire."
fi

if [ ! -f "${lngpkg}" ] ; then
  die "Le package linguistique fourni en paramètre n'est pas valide."
fi

LNG_VERSION=$(zipinfo -1 $lngpkg |grep resource/VERSION|sed -e s';resource/VERSION_;;')
# TODO: test de validite sur le LNG_VERSION

docker_runnable_image=$(echo "${docker_compiled_image}_${LNG_VERSION}"|sed -e 's/compiled/runnable/')

iid=$(docker images -q $docker_runnable_image)
if [ "$iid" != "" ] ; then
  die "L'image ${docker_runnable_image} existe deja"
fi

echo "------------------------------"
echo "Construction de l'image Docker"
echo "------------------------------"
echo "Image docker Unitex              = ${docker_compiled_image}"
echo "Image docker Unitex+Linguistique = ${docker_runnable_image}"
echo "Paquet linguistique              = ${lngpkg}"
echo "Version du paquet linguistique   = ${LNG_VERSION}"
echo "------------------------------"
echo ""

builddir=$(dirname $0)/builddir

[ -d $builddir ] || mkdir $builddir

sed -e "s;@DOCKER_COMPILED_IMAGE@;${docker_compiled_image};" Dockerfile.tmpl > Dockerfile

rm -rf $builddir/*

cp $lngpkg $builddir
echo $LNG_VERSION > "$builddir/lng_version"
cp unitex.sh $builddir

docker build -t $docker_runnable_image --rm=true .
