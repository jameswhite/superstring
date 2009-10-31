class base::postfix_should_only_run_locally {
  file {"/etc/postfix":
    ensure => 'directory',
  }
  file {"/etc/postfix/main.cf":
    ensure => 'file',
    require => File['/etc/postfix']
  }

  exec {"neuter_postfix":
    command => "/bin/sed -i 's:^inet_interfaces.*:inet_interfaces = loopback-only:' /etc/postfix/main.cf",
    require => File["/etc/postfix/main.cf"]
  }

  service {"postfix":
    ensure    => running,
    enable    => true,
    require   => Exec["neuter_postfix"],
    subscribe => Exec["neuter_postfix"]
  }
}
