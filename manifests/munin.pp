class nsd::munin {
  munin::plugin::deploy{
    'nsd3':
      source => 'nsd/munin/nsd3' ,
      config => "env.pidfile /var/run/nsd/nsd.pid\nuser nsd";
  }
}

