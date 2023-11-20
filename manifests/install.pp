# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include netplan::install
class netplan::install {
  assert_private()

  package { $netplan::package_name:
    ensure => $netplan::package_ensure,
  }
}
