class base::ldap-client {
    ############################################################################    
    # link the domain cacert
    ############################################################################    
    file {'/etc/ldap/ssl':
        ensure => 'directory'
    }
    ############################################################################    
    # dynamic LDAP configuration via scripts
    ############################################################################    
    file { '/usr/local/sbin/ldap.conf-init':
        owner  => 'root',
        group  => 'root',
        mode   => '0744',
        source => 'puppet:///base/ldap/ldap.conf-init'
    }
    file { '/usr/local/sbin/testldap':
        owner  => 'root',
        group  => 'root',
        mode   => '0744',
        source => 'puppet:///base/scripts/testldap'
    }
    exec { 'ldap-conf-init':
         path    => '/usr/local/sbin',
         command => 'ldap.conf-init',
         require => File['/usr/local/sbin/ldap.conf-init'],
    }
    ############################################################################    
    # pluggable authentication module configuration
    ############################################################################    
    file { '/etc/pam.d/common-account':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/pam.d/common-account'
    }
    file { '/etc/pam.d/common-auth':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/pam.d/common-auth'
    }
    file { '/etc/pam.d/common-password':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/pam.d/common-password'
    }
    file { '/etc/pam.d/common-session':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/pam.d/common-session'
    }
    file {'/etc/pam_ldap.conf':
        ensure => 'link',
        target => '/etc/ldap/ldap.conf',
    }
    ############################################################################    
    # name service switch
    ############################################################################    
    file { '/etc/nsswitch.conf':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/ldap/nsswitch.conf'
    }
    file {'/etc/libnss-ldap.conf':
        ensure => 'link',
        target => '/etc/ldap/ldap.conf',
    }
    ############################################################################    
    # name service cache daemon
    ############################################################################    
    exec { 'flush-users':
         path    => '/usr/bin',
         command => 'nscd -i passwd; true',
         require => File['/etc/nsswitch.conf'],
         subscribe => File['/etc/nsswitch.conf'],
         require => Package['nscd'],
         refreshonly => 'true'
    }
    exec { 'flush-groups':
         path    => '/usr/bin',
         command => 'nscd -i group; true',
         require => File['/etc/nsswitch.conf'],
         subscribe => File['/etc/nsswitch.conf'],
         require => Package['nscd'],
         refreshonly => 'true'
    }
    exec { 'restart-nscd':
         path => '/etc/init.d',
         command => 'nscd restart;true',
         require => File['/etc/nsswitch.conf'],
         subscribe => File['/etc/nsswitch.conf'],
         require => Package['nscd'],
         refreshonly => 'true'
    }
}
