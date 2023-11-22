# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
# @param type
# @return String
function netplan::get::type(
  String $type
) >> String {
  case $type {
    /dummy|dummy-devices/: { 'dummy-devices' }
    /virtual|virt|virtual-ethernets/: { 'virtual-ethernets' }
    /wifi|wireless|wifis/: { 'wifis' }
    /modem|modems/: { 'modems' }
    /bridge|br|bridges/: { 'bridges' }
    /vrf|vrfs/: { 'vrfs' }
    /tunnel|tun|tunnels/: { 'tunnels' }
    /bond|bonding|bonds/: { 'bonds' }
    /vlan|vlans/: { 'vlans' }
    /eth|ethernet|ethernets/: { 'ethernets' }
    default: {
      fail('Unsupported interface type specified.')
    }
  }
}
