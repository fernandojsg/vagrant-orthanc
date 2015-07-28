#
# Defaults.
#
node default {

    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-update':
        command => '/usr/bin/apt-get update',
    }

    Exec["apt-update"] -> Package <| |>


    # Postgresql general config
    class { 'postgresql::globals':
        version             => "9.4",
        manage_package_repo => true,
        encoding             => "UTF8",
        #locale              => "en_EN.UTF-8"
    }

    class { "postgresql::server":
        # Postgresql server config
        ip_mask_deny_postgres_user => '0.0.0.0/32',
        ip_mask_allow_all_users    => '0.0.0.0/0',
        listen_addresses           => '*',
        ipv4acls                   => ['host all all 0.0.0.0/0 md5'],
        postgres_password          => 'pgpassword',
    }

    postgresql::server::db { 'orthanc':
        user     => 'pgorthancuser',
        password => postgresql_password('pgorthancuser', 'pgorthancpass'),
        before => Service['orthanc']
    }

    include orthanc
    include orthancdicomweb
    include orthancwebviewer
    include orthancpostgresql
    
}