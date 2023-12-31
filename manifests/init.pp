# @summary Install Netplan
#
# @param noop
#   The configuration will be added but not applied
# @param package_name
# @param package_ensure
# @param config_file
# @param replace
# @param config_version
# @param config_hash
#
# @example
#   include netplan
class netplan (
  Boolean $noop = true,
  String $package_name = 'netplan',
  String $package_ensure = 'present',
  String $config_file = '/etc/netplan/netplan.yaml',
  Boolean $replace = true,
  Enum['NetworkManager', 'networkd'] $renderer = 'networkd',
  Integer $config_version = 2,
  Hash $config_hash = {
    'network' => {
      'version'  => $config_version,
      'renderer' => $renderer
    }
  }
) {
  $warning_message = @("EOL")
  The module ${name} has been started in NOOP mode.
  A configuration file will be added. To try the configuration run

  `netplan try --config-file ${config_file}`

  After verification, set the flag

  `netplan::noop: false`
  | EOL
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
  unless $noop {
    Exec <| tag == 'netplan_flush' |>
    -> exec { 'Run netplan apply':
      command     => '/usr/sbin/netplan apply',
      refreshonly => true,
      subscribe   => Concat[$config_file]
    }
  } else { warning($warning_message) }
}
