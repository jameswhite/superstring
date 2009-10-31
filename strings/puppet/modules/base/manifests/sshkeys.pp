include base::ldap-client

class base::sshkeys {
    file { '/usr/local/sbin/authkeys':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///base/usr/local/sbin/authkeys',
        require => Exec['testldap'],
    }
    file { '/usr/local/sbin/allauthkeys':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///base/usr/local/sbin/allauthkeys',
        require => File['/usr/local/sbin/authkeys'],
        subscribe => File['/usr/local/sbin/authkeys']
    }
    exec { 'generate-sshkeys':
            path    => '/usr/local/sbin',
            command => 'allauthkeys',
            refreshonly => 'true',
            require => File['/usr/local/sbin/allauthkeys'],
            subscribe => File['/usr/local/sbin/allauthkeys']
         }
}
