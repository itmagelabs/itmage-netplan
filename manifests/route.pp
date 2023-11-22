# @summary Create route for $dev interface
#
# @param dev
# @param to
# @param via
# @param type
# @param opts
#
# @example
#   netplan::route { 'Added new route for Office net': dev => 'ens3', to => '172.10.0.1', via => '192.168.0.1' }
define netplan::route (
  String $dev,
  String $to,
  String $via,
  String $type = 'ethernets',
  Hash $opts = {}
) {
  $_type = netplan::get::type($type)
  $_route = [{ 'to' => $to, 'via' => $via } + $opts]
  $_h = {
    'network'   => {
      $_type => {
        $dev => {
          'routes' => $_route
        }
      }
    }
  }
  concat::fragment { "[netplan] route description: ${name}":
    target  => $netplan::config_file,
    content => to_yaml($_h)
  }
}
