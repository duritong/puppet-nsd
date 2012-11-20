class nsd(
  $interface = '',
  $manage_munin = false
) {
  include nsd::base
  if $manage_munin {
    include nsd::munin
  }
}
