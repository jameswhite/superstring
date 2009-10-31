################################################################################
# This class should attempt to normalize the systems as much as possible.
# The base class should do the following:
#   - Set up locales
#   - Set up the distribution's package manager to point to our prefered repos.
#   - Set up the kernel to pv_grub if possible
#   - If autofs4 will load, set up autodir else set up .profile to create ${HOME}
#   - Set up the host's nameservice as an LDAP client to the domain's ldap SRVs
#   - Set up the automatic ssh keys (/usr/local/sbin/allauthkeys)
#   - profit.
################################################################################
class base {
    include apt
    file { '/root/.ssh':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
    }
    file { '/usr/local/bin/gist':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///base/scripts/gist',
    }
    file { '/usr/local/sbin/pupprun':
        owner  => 'root',
        group  => 'root',
        mode   => '0744',
        source => 'puppet:///base/scripts/pupprun',
    }
    file { '/root/.ssh/authorized_keys':
        owner  => 'root',
        group  => 'root',
        mode   => '0640',
        source => 'puppet:///base/root/ssh-authorized_keys',
        require => File['/root/.ssh']
    }
    case $kernelrelease {
        '2.6.18-128.2.1.el5.028stab064.7': { include base::spry_vps }
        '2.6.18.8-linode16': { include base::linode_vps::pv_grub }
        '2.6.26-2-xen-686': { include base::autodir }
    }
    case $operatingsystem {
        'Debian': {
            include base::debian
            case $lsbdistcodename {
                'lenny': { include base::debian::lenny }
            }
        }
        'CentOS': {
            include base::debian
#            case $lsbdistrelease {
#                '5.4': { include base::centos::5.4 }
#            }
        }
    }
}

class base::debian {
    file { '/etc/locale.gen':
        owner  => 'root',
        group  => 'root',
        mode   => '0444',
        source => 'puppet:///base/locale/locale.gen',
        notify => Exec['generate-locale']
    }
    exec { 'generate-locale':
         path    => '/usr/bin',
         command => 'env PATH="/bin:/sbin:/usr/bin:/usr/sbin" /usr/sbin/locale-gen',
         require => File['/etc/locale.gen'],
         require => Package['locales'],
         subscribe => File['/etc/locale.gen'],
         refreshonly => 'true'
    }
}

class base::debian::lenny {
}

class base::spry_vps {
}