# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include netplan
class netplan (
  String $package_name = 'netplan',
  String $package_ensure = 'present',
  String $config_file = '/etc/netplan/netplan.yaml',
  Boolean $replace = true,
  Integer $config_version = 2,
  Hash $config_hash = {
    'network' => {
      'version'  => $config_version,
      'renderer' => 'networkd'
    }
  }
) {
  include netplan::install

  concat { $config_file:
    ensure  => present,
    replace => $replace,
    format  => 'yaml'
  }
  concat::fragment { '[netplan] HEAD':
    target  => $config_file,
    content => to_yaml($config_hash)
  }
  Exec <| tag == 'netplan_flush' |>
  -> exec { 'Run netplan apply':
    command     => '/usr/sbin/netplan apply',
    refreshonly => true,
    subscribe   => Concat[$config_file]
  }
}
