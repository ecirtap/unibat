#!/bin/bash

set -u 

function die() { 
  echo $1; exit 1 
}

docker_runnable_tag=""
directory=""
corpus=""
nthreads=2

while getopts ':t:n:d:c:' flag; do
  case "${flag}" in
    t) docker_runnable_tag="${OPTARG}"; docker_runnable_image="unitex/runnable:${docker_runnable_tag}" ;;
    n) nthreads="${OPTARG}" ;;
    d) directory="${OPTARG}" ;;
    c) corpus="${OPTARG}" ;;
    *) ;;
  esac
done

if [ "${docker_runnable_tag}" = "" ]; then
  die "Le tag de l'image docker qui sert a lancer Unitex (option -t) est obligatoire."
fi

iid=$(docker images -q $docker_runnable_image)
if [ "$iid" = "" ] ; then
  die "L'image ${docker_runnable_image} n'existe pas."
fi

if [ "${directory}" = "" ]; then
  die 'Le repertoire dans lequel doit se trouver le corpus à traiter (option -d) est obligatoire.'
fi

if [ ! -d $directory ] ; then
  die "Le repertoire dans lequel doit se trouver le corpus n'existe pas."
fi

if [ "${corpus}" = "" ]; then
  die "Le nom du corpus à traiter (option -c) est obligatoire."
fi

if [ ! -d "${directory}/${corpus}" ] ; then
  die "Le repertoire dans lequel doit se trouver le corpus n'existe pas."
fi

# On fait en sorte de rendre disponible le reste de la ligne de commande à ce qui suit (options non parsées)
shift "$((OPTIND - 2))"

outfile="${corpus}.log"
okfile="${corpus}.ok"
kofile="${corpus}.ko"
outpath="${directory}/${outfile}"

corpus_out="${corpus}.out"

rm -rf "${directory}/${corpus_out}"
rm -f "${directory}/${okfile}"
rm -f "${directory}/${kofile}"
mkdir -p "${directory}/${corpus_out}"

docker run --net none --rm -v "$directory/:/corpus" $docker_runnable_image -t $nthreads -i /corpus/$corpus -o /corpus/$corpus_out $@ > $outpath 2>&1

nbin=$(ls "${directory}/${corpus}"|wc -l)
nbout=$(ls "${directory}/${corpus_out}"|wc -l)

if [ $nbin -eq $nbout ] ; then
  touch "${directory}/${okfile}"
else
  touch "${directory}/${kofile}"
fi
