class base::apt {
    file { '/etc/apt/preferences':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/apt/preferences'
    }
    exec { 'backports-keyfetch':
        path => '/usr/bin',
        command => '/usr/bin/gpg --keyserver pgp.mit.edu --recv-keys EA8E8B2116BA136C',
        unless  => '/usr/bin/gpg --list-keys EA8E8B2116BA136C',
    }
    exec { 'backports-keyinstall':
        path => '/usr/bin',
        command => '/usr/bin/gpg --export -a  EA8E8B2116BA136C | apt-key add -',
        unless  => '/usr/bin/apt-key list | /bin/grep EA8E8B2116BA136C',
        notify  => Exec['apt-update'],
        require => Exec['backports-keyfetch']
    }

    $pkis = [ '/etc/pki', '/etc/pki/apt' ]  
    file { $pkis:
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
 
    file { '/etc/apt/sources.list':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/apt/sources.list',
        notify  => Exec['apt-update'],
        require => [ Exec['backports-keyinstall'], File['/etc/apt/preferences']  ],
    }
    exec { 'apt-update':
         command => '/usr/bin/apt-get update||/usr/bin/apt-get update||/usr/bin/apt-get update;true',
         subscribe => File['/etc/apt/sources.list'],
         refreshonly => 'true'
    }
}
