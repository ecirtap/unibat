Unibat
======

Un environnement Vagrant pour le packaging / test docker d'Unitex

    host% git clone https://github.com/ecirtap/unibat.git
    host% cd unibat
    host% mkdir tmp
    host% # Placer dans tmp une extraction d'unitex et de la demo
    host% vagrant up
    host% vagrant ssh
    vagrant@unitex% cd /vagrant/tmp
    vagrant@unitex% # Compiler Unitex, copier la lib so dans la démo
    vagrant@unitex% # Lancer la démo
    vagrant@unitex% cd /vagrant/unitex/build
    vagrant@unitex% ./build.sh
    vagrant@unitex% # Placer dans /corpus/in un ensemble de ressources à traiter
    vagrant@unitex% docker run -v /corpus:/corpus unitex
    
    
