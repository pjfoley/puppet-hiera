# == Class: hiera
#
# This class handles installing the hiera.yaml for Puppet's use.
#
# === Parameters:
#
# [*hierarchy*]
#   Hiera hierarchy.
#   Expects a array
#   Default: empty
#
# [*backends*]
#   Hiera backends.
#   Expects a hash
#   Default:
#     Puppet Enterprise - { 'yaml' => ['yaml'] { 'datadir' => '/etc/puppetlabs/puppet/hieradata' }
#     Open Source       - { 'yaml' => ['yaml'] { 'datadir' => '/etc/puppet/hieradata' }
#
# [*hiera_yaml*]
#   Heira config file.
#   Expects a string
#   Default: auto-set, platform specific
#
# [*owner*]
#   Owner of the files.
#   Expects a string
#   Default: auto-set, platform specific
#
# [*group*]
#   Group owner of the files.
#   Expects a string
#   Default: auto-set, platform specific
#
# [*extra_config*]
#   An extra string fragment of YAML to append to the config file.
#   Useful for configuring backend-specific parameters.
#   Default: ''
#
# [*no_backend*]
#   Do not use the modules autoload capability for these classes
#   Expects an array
#   Default: empty
#
# [*logger*]
#   Configure a valid hiera logger
#   Expects a string
#   Note: You need to manage any package/gem dependancies
#   Default: console
#
# [*merge_behavior*]
#   Configure hiera merge behavior.
#   Expects a string
#   Note: You need to manage any package/gem dependancies
#   Default: native
#
# [*cmdpath*]
#   Search paths for command binaries, like the 'eyaml' command.
#   The default should cover most cases.
#   Default: ['/opt/puppet/bin', '/usr/bin', '/usr/local/bin']
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir directories based on passed in backends hash
#
# === Requires:
#
# puppetlabs/stdlib
#
# === Sample Usage:
#
#   class { 'hiera':
#     hierarchy => [
#       '%{environment}',
#       'common',
#     ],
#     backends               => {
#       'eyaml'              => {
#         'datadir'          => '/etc/puppet/hieradata'
#         'extension'        => 'yaml'
#         'pkcs7_private_key => '/etc/puppet/keys/private_key.pkcs7.pem'
#         'pkcs7_public_key  => '/etc/puppet/keys/public_key.pkcs7.pem'
#       }
#       'yaml'               => {
#         'datadir'          => '/etc/puppet/hieradata'
#       }
#     }
#   }
#
# === Authors:
#
# Hunter Haugen <h.haugen@gmail.com>
# Mike Arnold <mike@razorsedge.org>
# Terri Haber <terri@puppetlabs.com>
# Greg Kitson <greg.kitson@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera (
  $hierarchy       = [],
  $backends        = $hiera::params::backends,
  $hiera_yaml      = $hiera::params::hiera_yaml,
  $datadir         = $hiera::params::datadir,
  $datadir_manage  = $hiera::params::datadir_manage,
  $owner           = $hiera::params::owner,
  $group           = $hiera::params::group,
  $eyaml           = false,
  $eyaml_datadir   = $hiera::params::datadir,
  $eyaml_extension = $hiera::params::eyaml_extension,
  $confdir         = $hiera::params::confdir,
  $logger          = $hiera::params::logger,
  $cmdpath         = $hiera::params::cmdpath,
  $merge_behavior  = undef,
  $extra_config    = '',
) inherits hiera::params {
  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  if ($datadir !~ /%\{.*\}/) and ($datadir_manage == true) {
    file { $datadir:
      ensure => directory,
    }
  }
  if $eyaml {
    require hiera::eyaml
  }
  # Template uses:
  # - $eyaml
  # - $backends
  # - $logger
  # - $hierarchy
  # - $datadir
  # - $eyaml_datadir
  # - $eyaml_extension
  # - $confdir
  # - $merge_behavior
  # - $extra_config
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
