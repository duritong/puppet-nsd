# Manage an NSD installation
#
# Parameters:
#
#  * interface: do you want to restrict listening to a certain ipaddress?
#  * manage_munin: do you want to manage munin plugin to monitor nsd?
class nsd(
  $interface        = '',
  $manage_munin     = false,
  $manage_shorewall = false
) {
  include nsd::base
  if $manage_munin {
    include nsd::munin
  }
  if $manage_shorewall {
    include shorewall::rules::dns
  }
}
