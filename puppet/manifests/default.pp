#
# Defaults.
#
node default {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  exec { 'apt-update':
    command => '/usr/bin/apt-get update',
  }

  Exec["apt-update"] -> Package <| |>
    

#    include orthanc
#    include orthancdicomweb
#    include orthancwebviewer

    # Postgresql general config
    class { 'postgresql::globals':
      version             => "9.4",
      manage_package_repo => true,
      encoding             => "UTF8",
      locale              => "en_EN.UTF-8"
    }

#    include orthancpostgresql

}