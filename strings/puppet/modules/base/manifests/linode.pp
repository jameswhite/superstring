class base::vps::linode::pv_grub {
    package { 'linux-image-xen-686': 
         ensure => 'latest' 
    }
    file { '/boot/grub':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        require => Package['linux-image-xen-686']
    }
    package { 'grub': 
         ensure => 'latest',
         require => File['/boot/grub'],
    }
    exec { 'update-grub':
         path    => '/usr/bin',
         command => 'env PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin" /usr/sbin/update-grub',
         require => Package['grub'],
    }
    file { '/etc/inittab.dist':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => '/etc/inittab',
        require => Exec['update-grub']
    }
    exec { '/etc/inittab':
        path=> "/bin",
        command => "sed -e 's/38400 tty1/38400 hvc0/' /etc/inittab.dist > /etc/inittab",
        require => File['/etc/inittab.dist']
    }
    file {'/etc/rc.local.dist':
        source  => '/etc/rc.local',
    }
    file {'/etc/rc.local':
        owner   => 'root',
        group   => 'root',
        mode    => '0744',
        source  => 'puppet:///base/etc/rc.local.secondboot',
        require => File['/etc/rc.local.dist']
    }

    exec { 'reboot-to-pv_grub':
         path    => '/sbin',
         command => 'reboot',
         require => Package['linux-image-xen-686'],
         require => Package['grub'],
         require => File['/boot/grub'],
         require => Exec['/etc/inittab'],
         require => Exec['update-grub'],
         require => File['/etc/rc.local'],
         require => Class['base::packages']
    }
}
