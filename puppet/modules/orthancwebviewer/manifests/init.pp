#
# orthanc
#
class orthancwebviewer {

#libgdcm2-dev libjpeg-dev postgresql-server-dev-all

    # Clone repo in the tmp build directory
    vcsrepo { '/root/orthanc-webviewer':
      ensure   => present,
      provider => hg,
      source   => 'https://bitbucket.org/sjodogne/orthanc-webviewer',
    }

    # Copy the build script to the tmp folder
    file { '/root/orthanc-webviewer.sh': 
        ensure => file, 
        mode => '+X',
        source => 'puppet:///modules/orthancwebviewer/orthanc-webviewer.sh', 
    }
    
    # Build orthanc from source code repo        
    exec { 'Build Orthanc webviewer': 
        command => '/root/orthanc-webviewer.sh',
        require => [ Vcsrepo ['/root/orthanc-webviewer'], Exec['Build Orthanc']],
        cwd => '/root/orthanc-webviewer',
        timeout => 0,
        logoutput => "on_failure",
        creates => '/usr/share/orthanc/plugins/libOrthancWebViewer.so'
    } -> # Define the service configuration to run with upstart
    file { '/usr/share/orthanc/plugins/libOrthancWebViewer.so':
        ensure  => file,
        links => follow,
        source  => '/root/orthanc-webviewer/Build/libOrthancWebViewer.so',
        notify => Service['orthanc'],
        #require => Exec['Build Orthanc dicomweb']
    }

}