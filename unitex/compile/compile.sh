#!/bin/bash

set -u

cmdpath=$(dirname $0)

cd $cmdpath

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


# Plus la peine de garder ces packages; on va faire maigrir l'image resultante
apt-get purge -qqy openjdk-7-jre openjdk-7-jdk subversion g++ valgrind make expect 
apt-get autoremove -qqy
