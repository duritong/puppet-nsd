# installs and configures munin plugin for nsd
class nsd::munin {

  # this is required on centos for the munin plugin to work
  nsd::conf{
    'log_file':
      content => "logfile: \"/var/log/nsd.log\"\n";
  }

  munin::plugin::deploy{
    'nsd_':
      source   => 'nsd/munin/nsd_' ,
      register => false;
  }
  munin::plugin{
    [ 'nsd_hits',
      'nsd_by_type',
      'nsd_by_rcode',
    ]:
      ensure  => 'nsd_',
      config  => 'user nsd',
      require => Munin::Plugin::Deploy['nsd_'];
  }
}

