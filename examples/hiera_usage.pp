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
  create_resources('netplan::interface', $interfaces, {})
  case $facts['role'] {
    /gateway|jumphost/: {create_resources('netplan::route', $routes['gateway'], {})}
    default: {}
  }
}
