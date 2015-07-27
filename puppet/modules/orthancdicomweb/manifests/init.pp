#
# orthanc
#
class orthancdicomweb {

#libgdcm2-dev libjpeg-dev postgresql-server-dev-all

    # Clone repo in the tmp build directory
    vcsrepo { '/root/orthanc-dicomweb':
      ensure   => present,
      provider => hg,
      source   => 'https://bitbucket.org/sjodogne/orthanc-dicomweb',
    }

    # Copy the build script to the tmp folder
    file { '/root/orthanc-dicomweb.sh': 
        ensure => file, 
        mode => '+X',
        source => 'puppet:///modules/orthancdicomweb/orthanc-dicomweb.sh', 
    }
    
    # Build orthanc from source code repo        
    exec { 'Build Orthanc dicomweb': 
        command => '/root/orthanc-dicomweb.sh',
        require => [ Vcsrepo ['/root/orthanc-dicomweb'], Exec['Build Orthanc']],
        cwd => '/root/orthanc-dicomweb',
        timeout => 0,
        logoutput => true
    } -> # Define the service configuration to run with upstart
    file { '/usr/share/orthanc/plugins/libOrthancDicomWeb.so':
        ensure  => file,
        links => follow,
        source  => '/root/orthanc-dicomweb/Build/libOrthancDicomWeb.so',
        notify => Service['orthanc'],
        #require => Exec['Build Orthanc dicomweb']
    }

}