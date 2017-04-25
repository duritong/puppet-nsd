# Manage an NSD installation
#
# Parameters:
#
#  * bind_ip_address: do you want to restrict listening to a certain ipaddress?
#                     Default: all - no restriction
#  * manage_munin: do you want to manage munin plugin to monitor nsd?
#                  Default: false
#  * manage_shorewall: open ports in shorewall?
#                      Default: false
#  * nagios_test_domain: a domain that should used for nagios tests
#                        Default: undef - no tests
class nsd(
  $bind_ip_address    = 'all',
  $manage_munin       = false,
  $manage_shorewall   = false,
  $nagios_test_domain = undef,
) {
  include ::nsd::base
  if $manage_munin {
    include ::nsd::munin
  }
  if $manage_shorewall {
    include ::shorewall::rules::dns
  }
  if $nagios_test_domain {
    $check_ip = $bind_ip_address ? {
      'all'   => pick($default_ipaddress,$ipaddress),
      default => $bind_ip_address,
    }
    nagios::service::dns{
      "nsd_${nagios_test_domain}":
        check_domain => $nagios_test_domain,
        ip           => $check_ip,
    }
  }
}
