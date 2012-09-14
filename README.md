## Example usage

### Standalone

    class {
      'redis':;
    }

### Master node

    class {
      'redis':
        bind        => '10.0.1.1';
       #masterauth  => 'secret';
    }

### Slave node

    class {
      'redis':
        bind        => '10.0.1.2',
        slaveof     => '10.0.1.1 6379';
       #masterauth  => 'secret';
    }

### Manage repositories

Disabled by default but if you really want the module to manage the required 
repositories you can use this snippet:

    class {
      'redis':
        manage_repo => true,
    }

