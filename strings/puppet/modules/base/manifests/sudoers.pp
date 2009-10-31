class base::sudoers {
    file { '/etc/sudoers.tmp':
        owner  => 'root',
        group  => 'root',
        mode   => '0440',
        source => 'puppet:///base/sudoers/sudoers'
    }
    file { '/etc/sudoers':
        owner     => 'root',
        group     => 'root',
        mode      => '0440',
        source    => '/etc/sudoers.tmp',
        require   => Exec['validate-sudoers'],
        subscribe => Exec['validate-sudoers'],
    }
    exec { 'validate-sudoers':
         path    => '/usr/sbin',
         command => 'visudo -c -f /etc/sudoers.tmp',
         require => File['/etc/sudoers.tmp'],
         subscribe => File['/etc/sudoers.tmp'],
         refreshonly => 'true'
    }
}
