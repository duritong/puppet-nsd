define nsd::conf(
  $ensure = present,
  $content = 'absent',
  $source = 'absent'
){
  file{"/etc/nsd/conf.d/${name}.conf":
    ensure => $ensure,
    notify => Exec['rebuild_nsd_config'],
    owner => root, group => 0, mode => 0644;
  }
  if $source != 'absent' {
    File["/etc/nsd/conf.d/${name}.conf"]{
      source => $source
    }   
  } else {
    File["/etc/nsd/conf.d/${name}.conf"]{
      content => $content,
    }   
  }

  file_line{"${name}_nsd_include":
    ensure  => $ensure,
    line    => "Include: /etc/nsd/conf.d/${name}.conf",
    path    => "/etc/nsd/conf.d/includes.conf",
  }
}

