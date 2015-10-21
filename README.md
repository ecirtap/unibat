Unibat
======

Un environnement Vagrant pour le packaging / runtime docker d'Unitex


## Construction de la machine virtuelle

    host% git clone https://github.com/ecirtap/unibat.git
    host% cd unibat
    host% mkdir tmp
    host% # Placer dans tmp une extraction d'unitex et de la demo
    host% vagrant up

## Construction de l'image Docker pour Unitex + ressources linguistiques

    host% vagrant ssh
    vagrant@unitex% cd /vagrant/tmp
    vagrant@unitex% # Compiler Unitex à partir des sources
    vagrant@unitex% # TODO: mettre un exemple avec la revision 4068
    vagrant@unitex% # Lancer le build
    vagrant@unitex% cd /vagrant/unitex/build
    vagrant@unitex% ./build.sh -u /vagrant/tmp/4068 -l /vagrant/tmp/PackageCassys.lingpkg

## Lancement d'un conteneur Unitex

    vagrant@unitex% # Placer dans ~/corpus/in un ensemble de ressources à traiter
    vagrant@unitex% docker run -i -t -v $HOME/corpus:/corpus unitex -i /corpus/in/en/tei -o /corpus/out/en/tei -f tei -l EN -V
    
    
