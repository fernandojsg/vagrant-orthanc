#
# orthanc
#
class orthancpostgresql {

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
      }


    # Clone repo in the tmp build directory
    vcsrepo { '/root/orthanc-postgresql':
      ensure   => present,
      provider => hg,
      source   => 'https://s.jodogne@code.google.com/p/orthanc-postgresql/',
    }

    # Copy the build script to the tmp folder
    file { '/root/orthanc-postgresql.sh': 
        ensure => file, 
        mode => '+X',
        source => 'puppet:///modules/orthancpostgresql/build.sh', 
    }
    
    # Build orthanc from source code repo        
    exec { 'Build Orthanc postgresql': 
        command => '/root/orthanc-postgresql.sh',
        require => [ Vcsrepo ['/root/orthanc-postgresql'], Exec['Build Orthanc']],
        cwd => '/root/orthanc-postgresql',
        timeout => 0,
        logoutput => "on_failure"
    } ->
    file { '/usr/share/orthanc/plugins/libOrthancPostgreSQLIndex.so':
        ensure  => file,
        links => follow,
        source  => '/root/orthanc-postgresql/Build/libOrthancPostgreSQLIndex.so',
        notify => Service['orthanc'],
    } ->
    file { '/usr/share/orthanc/plugins/libOrthancPostgreSQLStorage.so':
        ensure  => file,
        links => follow,
        source  => '/root/orthanc-postgresql/Build/libOrthancPostgreSQLStorage.so',
        notify => Service['orthanc'],
    }
}