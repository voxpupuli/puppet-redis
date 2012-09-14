require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe "redis" do

  let(:node) { 'redis' }
  let(:facts) { {:operatingsystem => 'Debian'} }
##  let(:pre_condition) {
##    "class { 'redis':; }"
##  }

  let(:title) { 'Verify parameters' }
  let(:params) {
    {
      :config_dir                   => '_config_dir_',
      :config_file                  => '_config_file_',
      :config_group                 => '_config_group_',
      :config_user                  => '_config_user_',
      :daemon_enable                => '_daemon_enable_',
      :daemon_ensure                => '_daemon_ensure_',
      :daemon_group                 => '_daemon_group_',
      :daemon_hasstatus             => '_daemon_hasstatus_',
      :daemon_name                  => '_daemon_name_',
      :daemon_user                  => '_daemon_user_',
      :manage_repo                  => '_manage_repo_',
      :package_deps                 => '_package_deps_',
      :package_ensure               => '_package_ensure_',
      :package_name                 => '_package_name_',
      :activerehashing              => '_activerehashing_',
      :appendfsync                  => '_appendfsync_',
      :appendonly                   => '_appendonly_',
      :auto_aof_rewrite_min_size    => '_auto_aof_rewrite_min_size_',
      :auto_aof_rewrite_percentage  => '_auto_aof_rewrite_percentage_',
      :bind                         => '_bind_',
      :daemonize                    => '_daemonize_',
      :databases                    => '_databases_',
      :dbfilename                   => '_dbfilename_',
      :hash_max_zipmap_entries      => '_hash_max_zipmap_entries_',
      :hash_max_zipmap_value        => '_hash_max_zipmap_value_',
      :list_max_ziplist_entries     => '_list_max_ziplist_entries_',
      :list_max_ziplist_value       => '_list_max_ziplist_value_',
      :log_dir                      => '_log_dir_',
      :log_file                     => '_log_file_',
      :log_level                    => '_log_level_',
      :no_appendfsync_on_rewrite    => '_no_appendfsync_on_rewrite_',
      :pid_file                     => '_pid_file_',
      :port                         => '_port_',
      :rdbcompression               => '_rdbcompression_',
      :set_max_intset_entries       => '_set_max_intset_entries_',
      :slave_serve_stale_data       => '_slave_serve_stale_data_',
      :slowlog_log_slower_than      => '_slowlog_log_slower_than_',
      :slowlog_max_len              => '_slowlog_max_len_',
      :timeout                      => '_timeout_',
      :vm_max_memory                => '_vm_max_memory_',
      :vm_max_threads               => '_vm_max_threads_',
      :vm_page_size                 => '_vm_page_size_',
      :vm_pages                     => '_vm_pages_',
      :vm_swap_file                 => '_vm_swap_file_',
      :workdir                      => '_workdir_',
      :zset_max_ziplist_entries     => '_zset_max_ziplist_entries_',
      :zset_max_ziplist_value       => '_zset_max_ziplist_value_',
    }
  }

  it do
    should contain_file('_config_file_').with_owner('_config_user_')
    should contain_file('_config_file_').with_group('_config_group_')
    should contain_file('_config_file_').with_owner('_config_user_')
    should contain_file('_config_file_').with_group('_config_group_')

    should contain_file('_config_file_').with_content(/_activerehashing_/)
    should contain_file('_config_file_').with_content(/_appendfsync_/)
    should contain_file('_config_file_').with_content(/_appendonly_/)
    should contain_file('_config_file_').with_content(/_auto_aof_rewrite_min_size_/)
    should contain_file('_config_file_').with_content(/_auto_aof_rewrite_percentage_/)
    should contain_file('_config_file_').with_content(/_bind_/)
    should contain_file('_config_file_').with_content(/_daemonize_/)
    should contain_file('_config_file_').with_content(/_databases_/)
    should contain_file('_config_file_').with_content(/_dbfilename_/)
    should contain_file('_config_file_').with_content(/_hash_max_zipmap_entries_/)
    should contain_file('_config_file_').with_content(/_hash_max_zipmap_value_/)
    should contain_file('_config_file_').with_content(/_list_max_ziplist_entries_/)
    should contain_file('_config_file_').with_content(/_list_max_ziplist_value_/)
    should contain_file('_config_file_').with_content(/_log_file_/)
    should contain_file('_config_file_').with_content(/_log_level_/)
    should contain_file('_config_file_').with_content(/_no_appendfsync_on_rewrite_/)
    should contain_file('_config_file_').with_content(/_pid_file_/)
    should contain_file('_config_file_').with_content(/_port_/)
    should contain_file('_config_file_').with_content(/_rdbcompression_/)
    should contain_file('_config_file_').with_content(/_set_max_intset_entries_/)
    should contain_file('_config_file_').with_content(/_slave_serve_stale_data_/)
    should contain_file('_config_file_').with_content(/_slowlog_log_slower_than_/)
    should contain_file('_config_file_').with_content(/_slowlog_max_len_/)
    should contain_file('_config_file_').with_content(/_timeout_/)
    should contain_file('_config_file_').with_content(/_vm_max_memory_/)
    should contain_file('_config_file_').with_content(/_vm_max_threads_/)
    should contain_file('_config_file_').with_content(/_vm_page_size_/)
    should contain_file('_config_file_').with_content(/_vm_pages_/)
    should contain_file('_config_file_').with_content(/_vm_swap_file_/)
    should contain_file('_config_file_').with_content(/_workdir_/)
    should contain_file('_config_file_').with_content(/_zset_max_ziplist_entries_/)
    should contain_file('_config_file_').with_content(/_zset_max_ziplist_value_/)
  end
end

