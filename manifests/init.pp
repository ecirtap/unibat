# -*- mode: ruby -*-
# vi: set ft=ruby :

node 'unitex.fqdn.org' {
  $one_day = 86400 # Une journée en secondes

  Exec {
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  # Un update au premier lancement de la VM, ou bien si le dernier update date d'une journée
  $first_run_update = '/root/.1strunupdate'
  exec { 'apt_1st_update':
    command => "apt-get update && touch ${first_run_update}",
    timeout => 0,
    creates => $first_run_update
  } 

  # Un update si le dernier update date de plus d'une journée
  exec { 'apt_daily_update':
    command => 'apt-get update',
    timeout => 0,
    onlyif  => "test \$(expr \$(date +%s) - \$(stat -c %Y /var/cache/apt/pkgcache.bin)) -gt ${one_day}"
  } 

  # Nobody is perfect
  package { 'language-pack-fr': 
    ensure => present,
    require => [Exec['apt_1st_update'], Exec['apt_daily_update']],
  }
  exec { 'locale-gen':
    command => 'locale-gen --lang fr_FR.UTF-8',
    require => Package['language-pack-fr'],
    unless  => 'grep -q fr_FR.UTF-8 /var/lib/locales/supported.d/local' 
  }
  exec { 'set-timezone':
    command => 'timedatectl set-timezone Europe/Paris',
    require => Exec['locale-gen'],
    unless  => 'timedatectl status|grep -q Europe/Paris'
  }

  # Installation des paquets nécessaires sur le host Docker
  # NB: c'est Vagrant qui installe Docker (cf provisionning dans Vagrantfile)
  package { ['unzip','curl','htop','p7zip-full','liburi-perl']: 
    ensure => present, 
    require => Exec['set-timezone']
  }
}
