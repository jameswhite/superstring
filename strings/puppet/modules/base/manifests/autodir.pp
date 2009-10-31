class base::autodir {
    package {'autodir':
        ensure => 'latest',
        require => File['/etc/apt/sources.list'],
    }
    file { '/etc/default/autodir':
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///base/autodir/autodir',
        require => Package['autodir'],
        notify => Exec['bounce-autodir'],
    }
    exec { 'install-autofs4':
        command => '/bin/echo "autofs4" >> /etc/modules',
        unless  => '/bin/grep autofs4 /etc/modules',
        notify  => Exec["modprobe-autofs4"]
    }
    exec { 'modprobe-autofs4':
         path        => '/sbin',
         command     => 'modprobe autofs4',
         require     => Exec['install-autofs4'],
         refreshonly => 'true'
    }
    exec { 'bounce-autodir':
         path      => '/etc/init.d/',
         command   => 'autodir restart',
         require   => Package['autodir'],
         require   => File['/etc/default/autodir'],
         require   => Exec['install-autofs4'],
         subscribe => File['/etc/default/autodir'],
         refreshonly => 'true'
    }
}
