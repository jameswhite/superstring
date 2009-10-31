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
    exec { 'wcyd-keyfetch':
        path => '/usr/bin',
        command => '/usr/bin/gpg --keyserver pgp.mit.edu --recv-keys E8FDD50D46940910',
        unless  => '/usr/bin/gpg --list-keys E8FDD50D46940910',
    }

    file { 'wcyd-gpgkey':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        path => '/etc/pki/apt/wcyd-gpgkey',
        source => 'puppet:///base/apt/wcyd-gpgkey',
    }
  
    $pkis = [ '/etc/pki', '/etc/pki/apt' ]  
    file { $pkis:
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
 
    exec { 'wcyd-keyimport':
        path => '/usr/bin',
        command => '/usr/bin/apt-key add /etc/pki/apt/wcyd-gpgkey',
        unless  => '/usr/bin/apt-key list | /bin/grep 1024D/8B3F1AA2',
        require => File['wcyd-gpgkey'],
        require => File['/etc/pki/apt']
    }

    exec { 'wcyd-keyinstall':
        path => '/usr/bin',
        command => '/usr/bin/gpg --export -a  E8FDD50D46940910 | apt-key add -',
        unless  => '/usr/bin/apt-key list | /bin/grep E8FDD50D46940910',
        notify  => Exec['apt-update'],
        require => Exec['wcyd-keyfetch']
    }
    file { '/etc/apt/sources.list':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/apt/sources.list',
        notify  => Exec['apt-update'],
        require => [ Exec['wcyd-keyinstall'], Exec['backports-keyinstall'], File['/etc/apt/preferences'], Exec['wcyd-keyimport']  ],
    }
    exec { 'apt-update':
         command => '/usr/bin/apt-get update||/usr/bin/apt-get update||/usr/bin/apt-get update;true',
         subscribe => File['/etc/apt/sources.list'],
         refreshonly => 'true'
    }
}
