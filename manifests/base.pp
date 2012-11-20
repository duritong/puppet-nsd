class nsd::base {
  package{'nsd':
    ensure => present,
  } -> file_line{'nsd_conf_includes':
    line => 'include: "/etc/nsd/conf.d/includes.conf"',
    file => '/etc/nsd/nsd.conf',
    notify => Exec['rebuild_nsd_config'],
  } -> file{
    '/etc/nsd/conf.d':
      ensure => directory,
      purge => true,
      force => true,
      recurse => true,
      owner   => root,
      group   => 0,
      mode    => '0644';
    '/etc/nsd/conf.d/includes.conf':
      ensure => present,
      owner   => root,
      group   => 0,
      mode    => '0644';
    '/etc/nsd/conf.d/server_interface.conf':
      content => $nsd::interface ? { 
        '' => '', 
        default => "interface: ${nsd::interface}\n"
      },
      owner   => root,
      group   => 0,
      mode    => '0644';
  } ~> exec{'rebuild_nsd_config':
    command => 'service nsd rebuild',
    refreshonly => true,
  } ~> service{'nsd':
    enable => true,
    ensure => running,
  }
}

