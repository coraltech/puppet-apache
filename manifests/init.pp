# Class: apache
#
# This class installs, configures, and manages Apache
#
# Supports Hiera
#
# Parameters:
#
#  See <examples/params.json> for Hiera keys.
#
# Actions:
#   - Install Apache
#   - Configure Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class apache (

  $package                            = $apache::params::package,
  $package_ensure                     = $apache::params::package_ensure,
  $service                            = $apache::params::service,
  $service_ensure                     = $apache::params::service_ensure,
  $use_dev                            = $apache::params::use_dev,
  $dev_ensure                         = $apache::params::dev_ensure,
  $dev_packages                       = $apache::params::dev_packages,
  $modules                            = $apache::params::modules,
  $config_file                        = $apache::params::config_file,
  $config_template                    = $apache::params::config_template,
  $vars_file                          = $apache::params::vars_file,
  $vars_template                      = $apache::params::vars_template,
  $vhost_dir                          = $apache::params::vhost_dir,
  $vhost_enable_dir                   = $apache::params::vhost_enable_dir,
  $conf_dir                           = $apache::params::conf_dir,
  $log_dir                            = $apache::params::log_dir,
  $run_dir                            = $apache::params::run_dir,
  $lock_dir                           = $apache::params::lock_dir,
  $user                               = $apache::params::user,
  $group                              = $apache::params::group,
  $locale                             = $apache::params::locale,
  $access_file                        = $apache::params::access_file,
  $apache_timeout                     = $apache::params::timeout,
  $keepalive                          = $apache::params::keepalive,
  $max_keepalive_requests             = $apache::params::max_keepalive_requests,
  $keepalive_timeout                  = $apache::params::keepalive_timeout,
  $mpm_prefork_start_servers          = $apache::params::mpm_prefork_start_servers,
  $mpm_prefork_min_spare_servers      = $apache::params::mpm_prefork_min_spare_servers,
  $mpm_prefork_max_spare_servers      = $apache::params::mpm_prefork_max_spare_servers,
  $mpm_prefork_max_clients            = $apache::params::mpm_prefork_max_clients,
  $mpm_prefork_max_requests_per_child = $apache::params::mpm_prefork_max_requests_per_child,
  $mpm_worker_start_servers           = $apache::params::mpm_worker_start_servers,
  $mpm_worker_min_spare_threads       = $apache::params::mpm_worker_min_spare_threads,
  $mpm_worker_max_spare_threads       = $apache::params::mpm_worker_max_spare_threads,
  $mpm_worker_thread_limit            = $apache::params::mpm_worker_thread_limit,
  $mpm_worker_threads_per_child       = $apache::params::mpm_worker_threads_per_child,
  $mpm_worker_max_clients             = $apache::params::mpm_worker_max_clients,
  $mpm_worker_max_requests_per_child  = $apache::params::mpm_worker_max_requests_per_child,
  $mpm_event_start_servers            = $apache::params::mpm_event_start_servers,
  $mpm_event_min_spare_threads        = $apache::params::mpm_event_min_spare_threads,
  $mpm_event_max_spare_threads        = $apache::params::mpm_event_max_spare_threads,
  $mpm_event_thread_limit             = $apache::params::mpm_event_thread_limit,
  $mpm_event_threads_per_child        = $apache::params::mpm_event_threads_per_child,
  $mpm_event_max_clients              = $apache::params::mpm_event_max_clients,
  $mpm_event_max_requests_per_child   = $apache::params::mpm_event_max_requests_per_child,
  $ulimit_max_files                   = $apache::params::ulimit_max_files,
  $restricted_files                   = $apache::params::restricted_files,
  $default_type                       = $apache::params::default_type,
  $log_formats                        = $apache::params::log_formats,

) inherits apache::params {

  #-----------------------------------------------------------------------------
  # Installation

  package { 'apache':
    name   => $package,
    ensure => $package_ensure,
  }

  if $use_dev == 'true' {
    package { 'apache_dev_packages':
      name    => $dev_packages,
      ensure  => $dev_ensure,
      require => Package['apache'],
    }
  }

  if ! empty($modules) {
    apache::module { $modules:
      require => Package['apache'],
    }
  }

  #-----------------------------------------------------------------------------
  # Configuration

  file { 'apache_vhost_dir':
    path    => $vhost_dir,
    ensure  => directory,
    require => Package['apache'],
  }

  if $vhost_enable_dir {
    file { 'apache_vhost_enable_dir':
      path    => $vhost_enable_dir,
      ensure  => directory,
      require => Package['apache'],
    }
  }

  if $config_file {
    file { 'apache_config_file':
      path    => $config_file,
      ensure  => present,
      content => template($config_template),
      require => Package['apache'],
      notify  => Service['apache'],
    }
  }

  if $conf_dir {
    file { 'apache_conf_dir':
      path      => $conf_dir,
      ensure    => directory,
      require   => Package['apache'],
    }
  }

  if $vars_file {
    file { 'apache_vars_file':
      path      => $vars_file,
      ensure    => present,
      content   => template($vars_template),
      require   => Package['apache'],
      notify    => Service['apache'],
    }
  }

  #-----------------------------------------------------------------------------
  # Service

  service { 'apache':
    name    => $service,
    ensure  => $service_ensure,
    enable  => true,
    require => [ File['apache_config_file'], File['apache_vars_file'] ],
  }
}
