# main class to setup things for nsd
class nsd::base {
  package{'nsd':
    ensure => present,
  } -> file_line{'nsd_conf_includes':
    line    => 'include: "/etc/nsd/conf.d/includes.conf"',
    file    => '/etc/nsd/nsd.conf',
    notify  => Exec['rebuild_nsd_config'],
  } -> file{
    '/etc/nsd/conf.d':
      ensure  => directory,
      purge   => true,
      force   => true,
      recurse => true,
      notify  => Exec['rebuild_nsd_config'],
      owner   => root,
      group   => 0,
      mode    => '0644';
    '/etc/nsd/conf.d/includes.conf':
      ensure  => present,
      notify  => Exec['rebuild_nsd_config'],
      owner   => root,
      group   => 0,
      mode    => '0644';
  }

  service{'nsd':
    ensure => running,
    enable => true,
  } -> exec{'rebuild_nsd_config':
    command     => 'service nsd reload',
    refreshonly => true,
  }

  if $nsd::interface != '' {
    nsd::conf{'server_interface':
      content => "interface: ${nsd::interface}\n";
    }
  }
}

