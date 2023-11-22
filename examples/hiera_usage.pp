# TODO
# netplan_common:
#   ens3:
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
# netplan_gateway_routes:
#     'Added new route for Office net':
#       dev: bond0
#       to: 172.10.0.1/16
#       via: 192.168.0.1
class profile::netplan {
  $interfaces = lookup('netplan_common', undef, undef, {})
  $routes = lookup('netplan_gateway_routes', undef, undef, {})

  create_resources('netplan::interface', $interfaces, {})
  if $facts['role'] in ['gateway'] {
    create_resources('netplan::route', $routes, {})
  }
}
