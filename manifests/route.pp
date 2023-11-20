# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   netplan::route { 'namevar': }
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
