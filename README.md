Unibat
======

Un environnement Vagrant pour le packaging / runtime docker d'Unitex.

Testé avec Vagrant 2.2.0 VirtualBox 5.2.4, Ubuntu 18.04 (g++-8, OpenJDK 8), Docker 18.06.01, Révision Github-Unitex 2915.



Il faut installer Vagrant et VirtualBox sur son poste de travail pour utiliser cet environnement, qui fonctionne aussi bien sous Linux que Windows ou MacOS. L'utilisation de Cygwin sous Windows est recommandée car elle est bien adaptée à l'utilisation conjointe de Vagrant, de git et de SSH. Docker est installé par Vagrant à la première utilisation de l'environnement.

## Principe de fonctionnement ##

  - On veut créer une image docker permettant de faire tourner sous une version d'Ubuntu particulière une révision d'Unitex associé à un paquet linguistique.
  - On commence par lancer un build qui associe Ubuntu de base et outils de compilation
  - On utilise ce build pour compiler une révision particulière d'Unitex
  - On utilise le résultat de ce build en y associant un paquet linguistique
  - Le résultat est une image docker "unitex/runnable" dont le tag fait mention de la version d'Ubuntu, de la révision d'Unitex, et de la version du paquet linguistique
  - Il est alors possible de faire un docker run de cette image en lui passant des paramètres que l'on passe habituellement à Unitex.

**Avertissement**: pas encore utilisable "tout terrain" (i.e: avec les versions publiques d'Unitex)

## Construction de la machine virtuelle

    host% git clone https://github.com/ecirtap/unibat.git
    host% cd unibat
    host% mkdir tmp
    host% vagrant up

## Prérequis

  - Placer dans tmp le zip file permettant de construire Unitex
  - Placer dans tmp les packages linguistiques à inclure dans les futures images docker

## Construction de l'image Docker pour Unitex + ressources linguistiques

    host% vagrant ssh
    vagrant@unitex% cd /vagrant/unitex/compile
    vagrant@unitex% ./build.sh -u 18.04 -r 2915 -z /vagrant/tmp/script_rebuild_unitex_gcc82_ubu1804.zip
    vagrant@unitex% cd /vagrant/unitex/build
    vagrant@unitex% ./build.sh -i unitex/compiled:18.04_2915 -l /vagrant/tmp/PackageCassys/2018_11_06/PackageCassys.lingpkg

## Lancement d'un conteneur Unitex

    vagrant@unitex% ./unitex.sh -t 18.04_2915_20181106 -d $HOME/evaluation -c Corpus_fre_eval2015-10 -n 15 -s eng_tei.uniscript
