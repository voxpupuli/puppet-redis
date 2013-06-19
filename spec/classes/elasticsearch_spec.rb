require 'spec_helper'

describe 'redis', :type => :class do
  let (:facts) { debian_facts }

  describe 'without parameters' do
    it { should create_class('redis') }
    it { should include_class('redis::preinstall') }
    it { should include_class('redis::install') }
    it { should include_class('redis::config') }
    it { should include_class('redis::service') }

    it { should contain_package('redis-server').with_ensure('present') }

    it { should contain_file('/etc/redis.conf').with(
        'ensure' => 'present'
      )
    }

    it { should contain_service('redis-server').with(
        'ensure'     => 'running',
        'enable'     => 'true',
        'hasrestart' => 'true',
        'hasstatus'  => 'false'
      )
    }
  end

  describe 'with parameter: activerehashing' do
    let (:params) { { :activerehashing => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^activerehashing _VALUE_/
      )
    }
  end

  describe 'with parameter: appendfsync' do
    let (:params) { { :appendfsync => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^appendfsync _VALUE_/
      )
    }
  end

  describe 'with parameter: appendonly' do
    let (:params) { { :appendonly => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^appendonly _VALUE_/
      )
    }
  end

  describe 'with parameter: auto_aof_rewrite_min_size' do
    let (:params) { { :auto_aof_rewrite_min_size => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^auto-aof-rewrite-min-size _VALUE_/
      )
    }
  end

  describe 'with parameter: auto_aof_rewrite_percentage' do
    let (:params) { { :auto_aof_rewrite_percentage => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^auto-aof-rewrite-percentage _VALUE_/
      )
    }
  end

  describe 'with parameter: bind' do
    let (:params) { { :bind => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^bind _VALUE_/
      )
    }
  end

  describe 'with parameter: config_dir' do
    let (:params) { { :config_dir => '_VALUE_' } }

    it { should contain_file('_VALUE_').with_ensure('directory') }
  end

  describe 'with parameter: config_dir_mode' do
    let (:params) { { :config_dir_mode => '_VALUE_' } }

    it { should contain_file('/etc/redis').with_mode('_VALUE_') }
  end

  describe 'with parameter: config_file' do
    let (:params) { { :config_file => '_VALUE_' } }

    it { should contain_file('_VALUE_') }
  end

  describe 'with parameter: config_file_mode' do
    let (:params) { { :config_file_mode => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with_mode('_VALUE_') }
  end

  describe 'with parameter: config_group' do
    let (:params) { { :config_group => '_VALUE_' } }

    it { should contain_file('/etc/redis').with_group('_VALUE_') }
  end

  describe 'with parameter: config_owner' do
    let (:params) { { :config_owner => '_VALUE_' } }

    it { should contain_file('/etc/redis').with_owner('_VALUE_') }
  end

  describe 'with parameter: daemonize' do
    let (:params) { { :daemonize => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^daemonize _VALUE_/
      )
    }
  end

  describe 'with parameter: databases' do
    let (:params) { { :databases => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^databases _VALUE_/
      )
    }
  end

  describe 'with parameter: dbfilename' do
    let (:params) { { :dbfilename => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^dbfilename _VALUE_/
      )
    }
  end

  describe 'with parameter: hash_max_zipmap_entries' do
    let (:params) { { :hash_max_zipmap_entries => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^hash-max-zipmap-entries _VALUE_/
      )
    }
  end

  describe 'with parameter: hash_max_zipmap_value' do
    let (:params) { { :hash_max_zipmap_value => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^hash-max-zipmap-value _VALUE_/
      )
    }
  end

  describe 'with parameter: list_max_ziplist_entries' do
    let (:params) { { :list_max_ziplist_entries => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^list-max-ziplist-entries _VALUE_/
      )
    }
  end

  describe 'with parameter: list_max_ziplist_value' do
    let (:params) { { :list_max_ziplist_value => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^list-max-ziplist-value _VALUE_/
      )
    }
  end

  describe 'with parameter: log_dir' do
    let (:params) { { :log_dir => '_VALUE_' } }

    it { should contain_file('_VALUE_').with_ensure('directory') }
  end

  describe 'with parameter: log_file' do
    let (:params) { { :log_file => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^logfile _VALUE_/
      )
    }
  end

  describe 'with parameter: log_level' do
    let (:params) { { :log_level => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^loglevel _VALUE_/
      )
    }
  end

  describe 'with parameter: manage_repo' do
    let (:params) { { :manage_repo => true } }

    context 'on Debian' do
      let (:facts) { debian_facts }

      it { should_not create_yumrepo('epel') }
    end

    context 'on RHEL 6' do
      let (:facts) {
        {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemrelease => '6'
        }
      }

      it { should create_yumrepo('epel').with_enabled(1) }
    end
  end

  describe 'with parameter: masterauth' do
    let (:params) { { :masterauth => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^masterauth _VALUE_/
      )
    }
  end

  describe 'with parameter: no_appendfsync_on_rewrite' do
    let (:params) { { :no_appendfsync_on_rewrite => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^no-appendfsync-on-rewrite _VALUE_/
      )
    }
  end

  describe 'with parameter: package_ensure' do
    let (:params) { { :package_ensure => '_VALUE_' } }

    it { should contain_package('redis-server').with_ensure('_VALUE_') }
  end

  describe 'with parameter: package_name' do
    let (:params) { { :package_name => '_VALUE_' } }

    it { should contain_package('_VALUE_') }
  end

  describe 'with parameter: pid_file' do
    let (:params) { { :pid_file => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^pidfile _VALUE_/
      )
    }
  end

  describe 'with parameter: port' do
    let (:params) { { :port => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^port _VALUE_/
      )
    }
  end

  describe 'with parameter: rdbcompression' do
    let (:params) { { :rdbcompression => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^rdbcompression _VALUE_/
      )
    }
  end

  describe 'with parameter: repl_ping_slave_period' do
    let (:params) { { :repl_ping_slave_period => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^repl-ping-slave-period _VALUE_/
      )
    }
  end

  describe 'with parameter: repl_timeout' do
    let (:params) { { :repl_timeout => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^repl-timeout _VALUE_/
      )
    }
  end

  describe 'with parameter: service_enable' do
    let (:params) { { :service_enable => true } }

    it { should contain_service('redis-server').with_enable(true) }
  end

  describe 'with parameter: service_ensure' do
    let (:params) { { :service_ensure => '_VALUE_' } }

    it { should contain_service('redis-server').with_ensure('_VALUE_') }
  end

  describe 'with parameter: service_group' do
    let (:params) { { :service_group => '_VALUE_' } }

    it { should contain_file('/var/log/redis').with_group('_VALUE_') }
  end

  describe 'with parameter: service_hasrestart' do
    let (:params) { { :service_hasrestart => true } }

    it { should contain_service('redis-server').with_hasrestart(true) }
  end

  describe 'with parameter: service_hasstatus' do
    let (:params) { { :service_hasstatus => true } }

    it { should contain_service('redis-server').with_hasstatus(true) }
  end

  describe 'with parameter: service_name' do
    let (:params) { { :service_name => '_VALUE_' } }

    it { should contain_service('_VALUE_').with_name('_VALUE_') }
  end

  describe 'with parameter: service_user' do
    let (:params) { { :service_user => '_VALUE_' } }

    it { should contain_file('/var/log/redis').with_owner('_VALUE_') }
  end

  describe 'with parameter: set_max_intset_entries' do
    let (:params) { { :set_max_intset_entries => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^set-max-intset-entries _VALUE_/
      )
    }
  end

  describe 'with parameter: slave_serve_stale_data' do
    let (:params) { { :slave_serve_stale_data => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^slave-serve-stale-data _VALUE_/
      )
    }
  end

  describe 'with parameter: slaveof' do
    context 'binding to localhost' do
      let (:params) { { :slaveof => '_VALUE_' } }

      it do
        expect {
          should create_class('redis')
        }.to raise_error(Puppet::Error, /Replication is not possible/)
      end
    end

    context 'binding to external ip' do
      let (:params) {
        {
          :bind    => '10.0.0.1',
          :slaveof => '_VALUE_'
        }
      }

      it { should contain_file('/etc/redis.conf').with(
        'content' => /^slaveof _VALUE_/
      )
    }
    end
  end

  describe 'with parameter: slowlog_log_slower_than' do
    let (:params) { { :slowlog_log_slower_than => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^slowlog-log-slower-than _VALUE_/
      )
    }
  end

  describe 'with parameter: slowlog_max_len' do
    let (:params) { { :slowlog_max_len => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^slowlog-max-len _VALUE_/
      )
    }
  end

  describe 'with parameter: timeout' do
    let (:params) { { :timeout => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^timeout _VALUE_/
      )
    }
  end

  describe 'with parameter: vm_max_memory' do
    let (:params) { { :vm_max_memory => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^vm-max-memory _VALUE_/
      )
    }
  end

  describe 'with parameter: vm_max_threads' do
    let (:params) { { :vm_max_threads => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^vm-max-threads _VALUE_/
      )
    }
  end

  describe 'with parameter: vm_page_size' do
    let (:params) { { :vm_page_size => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^vm-page-size _VALUE_/
      )
    }
  end

  describe 'with parameter: vm_pages' do
    let (:params) { { :vm_pages => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^vm-pages _VALUE_/
      )
    }
  end

  describe 'with parameter: vm_swap_file' do
    let (:params) { { :vm_swap_file => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^vm-swap-file _VALUE_/
      )
    }
  end

  describe 'with parameter: workdir' do
    let (:params) { { :workdir => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^dir _VALUE_/
      )
    }
  end

  describe 'with parameter: zset_max_ziplist_entries' do
    let (:params) { { :zset_max_ziplist_entries => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^zset-max-ziplist-entries _VALUE_/
      )
    }
  end

  describe 'with parameter: zset_max_ziplist_value' do
    let (:params) { { :zset_max_ziplist_value => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with(
        'content' => /^zset-max-ziplist-value _VALUE_/
      )
    }
  end
end

