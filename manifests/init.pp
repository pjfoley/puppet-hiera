# == Class: hiera
#
# This class handles installing the hiera.yaml for Puppet's use.
#
# === Parameters:
#
# [*hierarchy*]
#   Hiera hierarchy.
#   Default: empty
#
# [*backends*]
#   Hiera backends.
#   Default:
#     Puppet Enterprise - { 'yaml' => { 'datadir' => '/etc/puppetlabs/puppet/hieradata' }
#     Open Source       - { 'yaml' => { 'datadir' => '/etc/puppet/hieradata' }
#
# [*hiera_yaml*]
#   Heira config file.
#   Default: auto-set, platform specific
#
# [*owner*]
#   Owner of the files.
#   Default: auto-set, platform specific
#
# [*group*]
#   Group owner of the files.
#   Default: auto-set, platform specific
#
# [*extra_config*]
#   An extra string fragment of YAML to append to the config file.
#   Useful for configuring backend-specific parameters.
#   Default: ''
#
# [*no_backend*]
#   Do these backend classes
#   Default: ['file']
#
# [*logger*]
#   Configure a valid hiera logger
#   Note: You need to manage any package/gem dependancies
#   Default: console
#
# [*merge_behavior*]
#   Configure hiera merge behavior.
#   Note: You need to manage any package/gem dependancies
#   Default: native
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'hiera':
#     hierarchy => [
#       '%{environment}',
#       'common',
#     ],
#   }
#
# === Authors:
#
# Hunter Haugen <h.haugen@gmail.com>
# Mike Arnold <mike@razorsedge.org>
# Terri Haber <terri@puppetlabs.com>
# Peter Foley <peter@ifoley.id.au>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
# Copyright (C) 2014 Peter Foley, unless otherwise noted.
#
class hiera (
  $hierarchy     = [],
  $backends      = $hiera::params::backends,
  $hiera_yaml    = $hiera::params::hiera_yaml,
  $owner         = $hiera::params::owner,
  $group         = $hiera::params::group,
  $no_backend    = $hiera::params::no_backend,
  $confdir       = $hiera::params::confdir,
  $logger         = $hiera::params::logger,
  $merge_behavior = undef,
  $extra_config  = '',
) inherits hiera::params {

  validate_hash($backends)

  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  $datadirs = datadirs($backends) 
  file { $datadirs:
    ensure => directory,
  }

  # Extract hash keys and remove backends the user does not want managed
  # Allow the user to pass either a string or an array.
  if is_array($no_backend) {
    $keys = difference(keys($backends), $no_backend)
  }
  else {
    $keys = delete(keys($backends), $no_backend)
  }

  hiera::load_backend{$keys :
    backends => $backends,
    owner    => $owner,
    group    => $group,
  }

  # Template uses $hierarchy, $backends
  file { $hiera_yaml:
    ensure  => present,
    content => template('hiera/hiera.yaml.erb'),
  }
  # Symlink for hiera command line tool
  file { '/etc/hiera.yaml':
    ensure => symlink,
    target => $hiera_yaml,
  }
}
