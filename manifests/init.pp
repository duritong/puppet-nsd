# Manage an NSD installation
#
# Parameters:
#
#  * interface: do you want to restrict listening to a certain ipaddress?
#  * manage_munin: do you want to manage munin plugin to monitor nsd?
#  * manage_shorewall: open ports in shorewall?
#  * nagios_test_domains: an array of domains that should tested to be resolved
class nsd(
  $interface           = '',
  $manage_munin        = false,
  $manage_shorewall    = false,
  $nagios_test_domain = 'absent'
) {
  include nsd::base
  if $manage_munin {
    include nsd::munin
  }
  if $manage_shorewall {
    include shorewall::rules::dns
  }
  if $nagios_test_domains != 'absent' {
    nagios::service::dns{
      "nsd_${nagios_test_domain}":
        check_domain  => $nagios_test_domain,
        ip            => $nsd::interface ? {
          ''      => $::ipaddress,
          default => $nsd::interface
        }   
    }   
  }
}
