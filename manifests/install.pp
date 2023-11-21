# @summary Install Netplan package
#
# @example
#   include netplan::install
class netplan::install {
  assert_private()

  package { $netplan::package_name:
    ensure => $netplan::package_ensure,
  }
}
