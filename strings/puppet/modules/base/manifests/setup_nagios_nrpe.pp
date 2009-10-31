class base::setup_nagios_nrpe {
  file {"/etc/nagios":
    ensure => directory,
    mode   => "0755",
    owner  => "root",
    group  => "root"
  }
  file {"/etc/nagios/nrpe.d":
    ensure => directory,
    mode   => "0755",
    owner  => "root",
    group  => "root",
    require => File['/etc/nagios']
  }
}
