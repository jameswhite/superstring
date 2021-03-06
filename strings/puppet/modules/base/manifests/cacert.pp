class base::cacert {
    ############################################################################
    # Install the CA certificate from the TXT record stored location
    ############################################################################
    file { '/usr/local/sbin/certinstall':
        owner  => 'root',
        group  => 'root',
        mode   => '0744',
        source => 'puppet:///base/usr/local/sbin/certinstall'
    }
    exec { 'certinstall':
         path    => '/usr/local/sbin',
         command => 'certinstall',
         require => File['/usr/local/sbin/certinstall']
    }
    exec { 'c_rehash':
         path    => '/usr/bin',
         command => 'c_rehash',
         require => Exec['certinstall']
    }
}
