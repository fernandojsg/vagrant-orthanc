#
# orthanc
#
class orthanc {

    package { [ 'wget','nano','build-essential','unzip','cmake','mercurial',
                'uuid-dev','libcurl4-openssl-dev','liblua5.1-0-dev','libgtest-dev',
                'libgoogle-glog-dev', 'libjsoncpp-dev', 'libpugixml-dev',
                'libgdcm2-dev', 'libjpeg-dev', 'postgresql-server-dev-all',
                'libpng-dev','libsqlite3-dev','libssl-dev','zlib1g-dev','libdcmtk2-dev',
                'libboost-all-dev','libwrap0-dev','libcharls-dev' ]:
        ensure => installed,
        before => Exec['Build Orthanc']
    }

    # Copy the build script to the tmp folder
    file { '/root/orthanc.sh': 
        ensure => file, 
        mode => '+X',
        source => 'puppet:///modules/orthanc/orthanc.sh', 
    }
    
    # Clone repo in the tmp build directory
    vcsrepo { '/root/orthanc':
      ensure   => present,
      provider => hg,
      source   => 'https://s.jodogne@code.google.com/p/orthanc/',
    } ->  # Build orthanc from source code repo        
    exec { 'Build Orthanc': 
        command => '/root/orthanc.sh',
        require => [ Vcsrepo ['/root/orthanc'], File['/root/orthanc.sh'] ],
        cwd => '/root/orthanc',
        timeout => 0,
        logoutput => "on_failure"
    }

    file { ['/etc/orthanc' ]:
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0755'
    }

    # Copy configuration
    file { '/etc/orthanc/orthanc.json':
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => '0644',
        source  => 'puppet:///modules/orthanc/orthanc.json',
        notify  => Service['orthanc']
    }

    # Define the service configuration to run with upstart
    file { '/etc/init/orthanc.conf':
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => '0644',
        source  => 'puppet:///modules/orthanc/orthanc.conf',
        require => Exec['Build Orthanc']
    } -> # Make sure orthanc service is running
    service { 'orthanc':
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
    }

}