# @summary Provides anything required by the install class, such as package
#   repositories.
# @api private
class redis::preinstall {
  if $redis::manage_repo {
    if $facts['os']['name'] == 'Ubuntu' and $redis::ppa_repo {
      contain 'apt'
      apt::ppa { $redis::ppa_repo: }
    } elsif $facts['os']['family'] == 'Debian' and $redis::redis_apt_repo {
      include 'apt'

      apt::source { 'redis':
        location => $redis::apt_location,
        release  => $redis::apt_release,
        repos    => $redis::apt_repos,
        key      => {
          id          => $redis::apt_key_id,
          server      => $redis::apt_key_server,
          key_options => $redis::apt_key_options,
        },
      }
    }
  }
}
