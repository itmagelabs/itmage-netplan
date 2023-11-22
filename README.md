# netplan

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with netplan](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with netplan](#beginning-with-netplan)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The module is under development.

A Puppet module that installs and configures Netplan.

## Setup

### Setup Requirements

The following dependencies are required to use the module:

- concat >= '7.4.0'

### Beginning with netplan

To start using the module, you need to add it to the manifest.
Then, create resources with a description of the interfaces and routes. For example:

```puppet
include netplan
netplan::interface { 'ens3': addresses => ['192.168.0.1'] }
netplan::route { 'Added new route for Office net': dev => 'ens3', to => '172.10.0.1', via => '192.168.0.1' }
```

## Usage

The module can create interfaces for bonds and for VLANs. Here are examples of different configurations.

If you need to reset all the addresses from the interface before applying the new configuration

```puppet
netplan::interface { 'ens3':
  flush     => true,
  addresses => ['10.10.0.10/32']
}
```

Any additional parameters can be added through the $opts key

```puppet
  netplan::interface { 'ens3':
    opts      => {'mtu' => 1500},
    addresses => ['10.10.0.10/32']
  }
```

Example of Bond interface configuration

```puppet
  netplan::interface { 'bond0':
    type      => 'bonds',
    opts      => {
      'interfaces' => ['ens3', 'ens4'],
      'parameters' => {
        'mode'      => '802.3ad',
        'lacp-rate' => 'fast'
      }
    },
    addresses => ['10.10.0.10/32']
  }
```

Similarly, you can build a VLAN interface

```puppet
  netplan::interface { 'vlan20':
    type      => 'vlan',
    opts      => {
      'link' => 'bond0',
      'id'   => 20
    },
    addresses => ['10.10.0.10/32']
  }
```

## Limitations

- There are no tests to check the module works

## Development

- I need help adding snippets for working with different tunnels, such as Wireguard.
  TODO: Initialize basic wireguard support
