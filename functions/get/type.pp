# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function core_netplan::get::type(
  String $type
) >> String {
  case $type {
    /bond|bonding|bonds/: { 'bonds' }
    /vlan|vlans/: { 'vlans' }
    /eth|ethernet|ethernets/: { 'ethernets' }
    default: { 'ethernets'}
  }
}
