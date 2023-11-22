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
#
# profile::netplan::routes:
#   gateway:
#     'Added new route for Office net':
#       dev: bond0
#       to: 172.10.0.1/16
#       via: 192.168.0.1
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
      if has_key(profile::netplan::interfaces, 'bond0') {
        create_resources('netplan::route', $routes['gateway'], {})
      }
    }
    default: {}
  }
}
