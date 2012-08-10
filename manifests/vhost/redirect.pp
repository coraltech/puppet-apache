
define apache::vhost::redirect (

  $aliases             = $apache::params::aliases,
  $admin_email         = $apache::params::admin_email,
  $destination         = $apache::params::destination,
  $conf_dir            = $apache::params::os_apache_conf_dir,
  $vhost_dir           = $apache::params::os_apache_vhost_dir,
  $configure_firewall  = $apache::params::configure_firewall,
  $vhost_ip            = $apache::params::vhost_ip,
  $priority            = $apache::params::priority,
  $options             = $apache::params::options,
  $port                = $apache::params::default_port,
  $log_dir             = $apache::params::os_apache_log_dir,
  $error_log_level     = $apache::params::error_log_level,
  $port_template       = $apache::params::os_port_template,
  $vhost_template      = $apache::params::os_vhost_redirect_template,

) {

  #-----------------------------------------------------------------------------

  apache::vhost { "${priority}-${name}-redirect":
    aliases             => $aliases,
    doc_root            => undef,
    conf_dir            => $conf_dir,
    vhost_dir           => $vhost_dir,
    configure_firewall  => $configure_firewall,
    vhost_ip            => $vhost_ip,
    priority            => $priority,
    options             => $options,
    port                => $port,
    use_ssl             => 'false',
    log_dir             => $log_dir,
    error_log_level     => $error_log_level,
    admin_email         => $admin_email,
    extra               => {
      'destination'       => $destination,
    },
    port_template       => $port_template,
    vhost_template      => $vhost_template,
  }
}
