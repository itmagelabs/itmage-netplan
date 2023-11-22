# @summary Create interface $dev
#
# @param type
# @param dev
# @param addresses
# @param flush
# @param opts
#
# @example
#   netplan::interface { 'ens3': addresses => ['192.168.0.1'] }
define netplan::interface (
  String $type = 'ethernets',
  String $dev = $name,
  Array $addresses = [],
  Boolean $flush = false,
  Hash $opts = {}
) {
  $_type = netplan::get::type($type)
  $_dev = $addresses.empty ? {
    true    => $opts,
    default => { 'addresses' => $addresses } + $opts
  }
  $_h = {
    'network'   => {
      $_type => {
        $dev => $_dev
      }
    }
  }
  concat::fragment { "[netplan] interface ${dev}":
    target  => $netplan::config_file,
    content => to_yaml($_h)
  }
  if $flush {
    @exec { "Flush all settings on ${dev}":
      command => "/sbin/ip addr flush dev ${dev}",
      tag     => ['netplan_flush']
    }
  }
}
