#
# Defaults.
#
node default {

    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

    exec { 'apt-update':
        command => '/usr/bin/apt-get update',
    }

    Exec["apt-update"] -> Package <| |>

    include orthanc
    include orthancdicomweb
    include orthancwebviewer
    include orthancpostgresql

    class { 'nginx': }
    
    nginx::resource::vhost { 'localhost':
        proxy => 'http://localhost:8042',
        proxy_set_header => [ 
            'HOST $host', 
            'X-Real-IP $remote_addr' 
        ],
        location_cfg_append  => {
            add_header => {
                "'Access-Control-Allow-Origin'" => "'*'",
                "'Access-Control-Allow-Credentials'" => "'true'",
                "'Access-Control-Allow-Methods'" => "'GET, POST, OPTIONS'",
                "'Access-Control-Allow-Headers'" => "'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type'"
            },
        },
        rewrite_rules => ['/orthanc(.*) $1 break']
    }
}