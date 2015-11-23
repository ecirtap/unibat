#!/bin/bash

set -u

cmdpath=$(dirname $0)

cd $cmdpath

# On laisse un marqueur pour gcc pour ne pas oublier (il est supprimé en fin de compilation)
gcc --version|head -1 > gcc_version

# Traitement du Proxy éventuel pour SVN
if [ ! -z ${HTTP_PROXY_HOST} ] ; then
  [ ! -d $HOME/.subversion ] && mkdir $HOME/.subversion
  cat << HERE > $HOME/.subversion/servers
[global]
http-proxy-host = $HTTP_PROXY_HOST
http-proxy-port = $HTTP_PROXY_PORT
HERE
fi

# Récupere le certificat https autosigné de la forge 
./svninfo.expect

mkdir $UNITEX_REVISION
cd $UNITEX_REVISION
# Construction d'Unitex
unzip ../script_rebuild_unitex.zip
./mkUnitexLib.sh $UNITEX_REVISION
# Copie le resultat dans le repertoire d'execution
cp libUnitexJni.so ../
cp RunUnitexDynLib ../
cp showversion.sh ../

# Plus la peine de garder ces packages; on va faire maigrir plus tard l'image Docker resultante
apt-get purge -qqy openjdk-7-jre openjdk-7-jdk subversion g++ valgrind make expect 
apt-get autoremove -qqy
