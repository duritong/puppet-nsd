# main class to setup things for nsd
class nsd::base {
  package{'nsd':
    ensure => installed,
  }

  file{
    '/etc/nsd/conf.d':
      ensure  => directory,
      require => Package['nsd'],
      notify  => Exec['rebuild_nsd_config'],
      purge   => true,
      force   => true,
      recurse => true,
      owner   => root,
      group   => 0,
      mode    => '0644';
    '/etc/nsd/conf.d/includes.conf':
      ensure  => file,
      notify  => Exec['rebuild_nsd_config'],
      owner   => root,
      group   => 0,
      mode    => '0644';
  }

  exec{'rebuild_nsd_config':
    command     => '/usr/sbin/nsdc -c /etc/nsd/nsd.conf rebuild',
    refreshonly => true,
  } ~> service{'nsd':
    ensure => running,
    enable => true,
  }

  file_line{'nsd_conf_includes':
    line    => 'include: "/etc/nsd/conf.d/includes.conf"',
    path    => '/etc/nsd/nsd.conf',
    require => File['/etc/nsd/conf.d/includes.conf'],
    notify  => Exec['rebuild_nsd_config'],
  }

  nsd::conf{'server_interface': }
  if $nsd::bind_ip_address != 'all' {
    Nsd::Conf['server_interface']{
      content => "ip-address: ${nsd::bind_ip_address}\n",
    }
  } else {
    Nsd::Conf['server_interface']{
      ensure => absent,
    }
  }
}

