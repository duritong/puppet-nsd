# main class to setup things for nsd
class nsd::base {
  package{'nsd':
    ensure => present,
  }
  
  file{
    '/etc/nsd/conf.d':
      ensure  => directory,
      require => Package['nsd'],
      purge   => true,
      force   => true,
      recurse => true,
      owner   => root,
      group   => 0,
      mode    => '0644';
    '/etc/nsd/conf.d/includes.conf':
      ensure  => present,
      owner   => root,
      group   => 0,
      mode    => '0644';
  } ~> exec{'rebuild_nsd_config':
    command     => 'service nsd rebuild',
    refreshonly => true,
  } ~> service{'nsd':
    ensure => running,
    enable => true,
  }

  file_line{'nsd_conf_includes':
    line    => 'include: "/etc/nsd/conf.d/includes.conf"',
    file    => '/etc/nsd/nsd.conf',
    require => File['/etc/nsd/conf.d/includes.conf'],
    notify  => Exec['rebuild_nsd_config'],
  }
  
  if $nsd::interface != '' {
    nsd::conf{'server_interface':
      content => "interface: ${nsd::interface}\n";
    }
  }
}

