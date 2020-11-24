# Puppet Redis

[![License](https://img.shields.io/github/license/voxpupuli/puppet-redis.svg)](https://github.com/voxpupuli/puppet-redis/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-redis.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-redis)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-redis/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-redis)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/redis.svg)](https://forge.puppetlabs.com/puppet/redis)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/redis.svg)](https://forge.puppetlabs.com/puppet/redis)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/redis.svg)](https://forge.puppetlabs.com/puppet/redis)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/redis.svg)](https://forge.puppetlabs.com/puppet/redis)

## Example usage

### Standalone

```puppet
include ::redis
```

### Master node

```puppet
class { '::redis':
  bind => '10.0.1.1',
}
```

With authentication

```puppet
class { '::redis':
  bind       => '10.0.1.1',
  masterauth => 'secret',
}
```

### Slave node

```puppet
class { '::redis':
  bind    => '10.0.1.2',
  slaveof => '10.0.1.1 6379',
}
```

With authentication

```puppet
class { '::redis':
  bind       => '10.0.1.2',
  slaveof    => '10.0.1.1 6379',
  masterauth => 'secret',
}
```

### Redis 3.0 Clustering

```puppet
class { '::redis':
  bind                 => '10.0.1.2',
  appendonly           => true,
  cluster_enabled      => true,
  cluster_config_file  => 'nodes.conf',
  cluster_node_timeout => 5000,
}
```

### Multiple instances


```puppet
$listening_ports = [6379,6380,6381,6382]

class { '::redis':
  default_install => false,
  service_enable  => false,
  service_ensure  => 'stopped',
}

$listening_ports.each |$port| {
  $port_string = sprintf('%d',$port)
  redis::instance { $port_string:
    service_enable => true,
    service_ensure => 'running',
    port           => $port,
    bind           => $facts['networking']['ip'],
    dbfilename     => "${port}-dump.rdb",
    appendfilename => "${port}-appendonly.aof",
    appendfsync    => 'always',
    require        => Class['Redis'],
  }
}
```

### Manage repositories

Disabled by default but if you really want the module to manage the required
repositories you can use this snippet:

```puppet
class { '::redis':
  manage_repo => true,
}
```

On Ubuntu, "chris-lea/redis-server" ppa repo will be added. You can change it by using ppa_repo parameter:

```puppet
class { '::redis':
  manage_repo => true,
  ppa_repo    => 'ppa:rwky/redis',
}
```

**Warning** note that it requires [puppetlabs/apt](https://forge.puppet.com/puppetlabs/apt) on Ubuntu distros. On Red Hat [puppet/epel](https://forge.puppet.com/puppet/epel) is needed unless the installation is using Software Collections. In that case will install `centos-release-scl-rh` from CentOS extras. For RHEL or other RHEL-derivatives this isn't managed.

### Redis Sentinel

Optionally install and configuration a redis-sentinel server.

With default settings:

```puppet
include ::redis::sentinel
```

With adjustments:

```puppet
class { '::redis::sentinel':
  master_name      => 'cow',
  redis_host       => '192.168.1.5',
  failover_timeout => 30000,
}
```

### Soft dependency

When managing the repo, it either needs [puppetlabs/apt](https://forge.puppet.com/puppetlabs/apt) or [puppet/epel](https://forge.puppet.com/puppet/epel).

For administration of sysctl it depends on [herculesteam/augeasproviders_sysctl](https://forge.puppet.com/herculesteam/augeasproviders_sysctl).

## `redis::get()` function

This function is used to get data from redis.
You must have the 'redis' gem installed on your puppet master.

Functions are documented in [REFERENCE.md](REFERENCE.md)
