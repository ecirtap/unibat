#!/bin/bash

set -u

function die() { 
  echo $1; exit 1 
}

ubuntu_version=''
unitex_revision=''
rebuild_unitex_zip=''

cmdpath=$(dirname $0)

while getopts 'u:z:r:' flag; do
  case "${flag}" in
    u) ubuntu_version="${OPTARG}" ;;
    r) unitex_revision="${OPTARG}" ;;
    z) rebuild_unitex_zip="${OPTARG}" ;;
    *) echo "option inconnue ${flag}"; exit 1 ;;
  esac
done

if [ "$ubuntu_version" = "" ] ; then
  die "Version d'ubuntu non specifiee (option -u)"
fi

if [ "$unitex_revision" = "" ] ; then
  die "Version d'unitex non specifiee (option -r)"
fi

if [ "$rebuild_unitex_zip" = "" ] ; then
  die "Le zip nécessaire à la compilation d'unitex n'est pas specifie (option -z)"
fi

if [ ! -f "$rebuild_unitex_zip" ] ; then
  die "Scripts pour compiler unitex introuvables: ${rebuild_unitex_zip}"
fi

cd $cmdpath

export UNITEX_REVISION=$unitex_revision

builddir="$cmdpath/builddir"
[ -d $builddir ] || mkdir $builddir
rm -rf $builddir/*

cp $rebuild_unitex_zip $builddir
cp compile.sh $builddir
cp svninfo.expect $builddir

if [ -z ${http_proxy+x} ] ; then
  h_proxy=""
else
  h_proxy="ENV http_proxy ${http_proxy}"
fi

if [ -z ${https_proxy+x} ] ; then
  hs_proxy=""
else
  hs_proxy="ENV https_proxy ${https_proxy}"
fi
set -x
sed -e "s/@UBUNTU_VERSION@/$ubuntu_version/" \
    -e "s;@HTTP_PROXY@;$h_proxy;" \
    -e "s;@HTTPS_PROXY@;$hs_proxy;" \
    Dockerfile.tmpl > Dockerfile

compiler_image_name="unitex/compiler:${ubuntu_version}"
compiled_image_name="unitex/compiled:${ubuntu_version}_${unitex_revision}"

# On construit l'image si elle n'existe pas
iid=$(docker images -q $compiler_image_name)
if [ "$iid" = "" ] ; then
  echo "L'image ${compiler_image_name} n'existe pas."
  docker build -t ${compiler_image_name} --rm=true .
else
  echo "L'image ${compiler_image_name} existe déjà"
fi

# On crée une image nouvelle à partir du résultat de la compilation
iid=$(docker images -q $compiled_image_name)
if [ "$iid" = "" ] ; then
  echo "L'image ${compiled_image_name} n'existe pas."
  # On lance le container qui va compiler l'image, et on prend soin de conserver son id
  cidfile=/tmp/cidfile.$$
  docker run --cidfile=$cidfile -e UNITEX_REVISION=$UNITEX_REVISION $compiler_image_name ./compile.sh
  cid=$(cat $cidfile)
  rm $cidfile
  docker export $cid | docker import --change='CMD ["bash"]' --change='WORKDIR /soft' - $compiled_image_name 
else
  echo "L'image ${compiled_image_name} existe déjà"
fi
