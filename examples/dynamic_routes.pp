# TODO
# profile::netplan::interfaces:
#   ens3:
#     flush: true
#     opts:
#       match:
#         name: ens3
#   bond0:
#     type: bond
#     addresses:
#       - 192.168.0.1/24
#     opts:
#       interfaces:
#         - ens3
#   vlan20:
#     type: vlan
#     opts:
#       link: bond0
#       id: 20
class profile::netplan (
  Hash $interfaces = {},
  Hash $routes = {}
) {
  $_interfaces = $facts['dc'] ? {
    /dub|cvt/ => deep_merge($interfaces, {'bond0' => { 'opts' => {'mtu' => 9000}}}),
    default   => $interfaces
  }
  create_resources('netplan::interface', $_interfaces, {})
  case $facts['role'] {
    /gateway|jumphost/: {
      $ips = puppetdb_query("facts[value] {
        certname in resources[certname] { type = 'Class' and title = 'Profile::Office' } and
        name = 'networking.ip' order by certname }").map |$i| {$i['value']}.sort
      $routes = $ips.reduce({}) |$memo, $ip| {
        $memo + {
          "Route via ${ip}" => {
            dev => lookup('default_be_interface', undef, undef, 'bond0'),
            to  => "${ip}/32",
            via => $facts['networking']['ip']
          }
        }
      }
      if has_key(profile::netplan::interfaces, 'bond0') {
        create_resources('netplan::route', $routes, {})
      }
    }
    default: {}
  }
}
