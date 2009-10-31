class base::packages {
  $packagePkgs = [ "apt", "apt-doc", "apt-utils", "debtags", "dpkg", "dpkg-dev" ]
  $buildPkgs   = [ "binutils", "build-essential", "cpp", "cpp-4.1", "g++", "g++-4.1", "gcc", "gcc-4.1","patch" ]
  $nagiosPkgs  = [ "nagios3", "nagios-nrpe-server", "nagios-plugins", "nagios-plugins-basic", "nagios-plugins-standard", "snmp" ]
  $ldapPkgs    = [ "libnss-ldap", "libpam-ldap", "nscd", "ldap-utils" ]
  $perlPkgs    = [ "perl", "perl-base", "perl-doc", "perl-modules" ]
  $pythonPkgs  = [ "python", "python2.5", "python2.5-minimal", "python-apt", "python-central", "python-minimal", "python-setuptools" ]
  $cifsPkgs    = [ "samba-common", "smbclient", "smbfs" ]
  $utilPkgs    = [ "bc", "bzip2", "console-setup", "console-terminus", "console-tools", "less", "screen", "sudo" ]
  $netutilPkgs = [ "iproute", "ethtool", "fping" ]
  $libPkgs     = [ "libapr1", "libaprutil1", "libatm1", "libc6-dev", "libcrypt-des-perl", "libcurl3-gnutls", "libcwidget3", "libcwidget-dev", "libdbi-perl", "libdbus-1-3", "libdigest-hmac-perl", "libdigest-sha1-perl", "libept0", "liberror-perl", "libexpat1", "libfribidi0", "libgpm2", "libidn11", "libio-socket-inet6-perl", "libkadm55", "libkeyutils1", "libklibc", "libkrb5-dev", "liblocale-gettext-perl", "liblockfile1", "liblzo2-2", "libmagic1", "libncursesw5", "libneon26", "libnet-daemon-perl", "libnet-snmp-perl", "libpam-foreground", "libparse-debianchangelog-perl", "libpci2", "libpcre3", "libperl5.10", "libplrpc-perl", "libpopt0", "libpq-dev", "libradius1", "libradiusclient-ng2", "libsasl2-modules", "libsensors3", "libsnmp15", "libsnmp-base", "libsqlite3-0", "libssl-dev", "libstdc++6-4.1-dev", "libsvn1", "libsysfs2", "libtalloc1", "libterm-readline-gnu-perl", "libterm-readline-perl-perl", "libtext-charwidth-perl", "libtext-iconv-perl", "libvolume-id0", "libwbclient0", "libxapian15", "libxml2" ]
$otherPkgs    = [ "comerr-dev", "dash", "gettext-base", "inetutils-inetd", "initramfs-tools", "klibc-utils", "lm-sensors", "locales", "lsb-release", "lsof", "lzma", "mailx", "make", "mii-diag", "mime-support", "ntpdate", "openssl", "pciutils", "pcmciautils", "postfix", "psmisc", "qstat", "radiusclient1", "rsync", "runit", "ssl-cert", "subversion", "tasksel", "tcl8.4", "telnet", "udev", "usbutils", "util-linux-locales", "vim", "vim-runtime", "whois", "xapian-tools", "xkb-data", "zlib1g-dev"]
    package { $packagePkgs:    ensure => installed }
    package { $buildPkgs:      ensure => installed }
    package { $nagiosPkgs:     ensure => installed }
    package { $ldapPkgs:       ensure => installed }
    package { $perlPkgs:       ensure => installed }
    package { $pythonPkgs:     ensure => installed }
    package { $cifsPkgs:       ensure => installed }
    package { $utilPkgs:       ensure => installed }
    package { $netutilPkgs:    ensure => installed }
    package { $libPkgs:        ensure => installed }
    package { $otherPkgs:      ensure => installed }
}
