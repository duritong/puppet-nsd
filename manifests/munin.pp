# installs and configures munin plugin for nsd
class nsd::munin {

  # this is required on centos for the munin plugin to work
  nsd::conf{
    'log_file':
      content => "logfile: \"/var/log/nsd.log\"\n";
  }

  munin::plugin::deploy{
    'nsd3':
      source => 'nsd/munin/nsd3' ,
      # this is the centos pidfile
      config => "env.pidfile /var/run/nsd/nsd.pid\nuser nsd";
  }
}

