# == Class: hiera::backend::eyaml
#
# This class installs and configures hiera-eyaml
#
# === Authors:
#
# Terri Haber <terri@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera::backend::eyaml (
  $backends = $hiera::params::eyaml_backends,
  $provider = $hiera::params::provider,
  $owner    = $hiera::params::owner,
  $group    = $hiera::params::group,
  $cmdpath  = $hiera::params::cmdpath,
) inherits hiera::params {

  $priv_key = extract_hashvalues($backends, 'pkcs7_private_key')
  $eyaml_files = extract_hashvalues($backends, ['pkcs7_private_key', '[pkcs7_public_key'])
  $keys_dir = dirname($priv_key[0])

  package { 'hiera-eyaml':
    ensure   => installed,
    provider => $provider,
  }

  file { 'eyaml_keys.dir':
    ensure => directory,
    path   => $keys_dir,
    owner  => $owner,
    group  => $group,
    mode   => '0500',
    before => Exec['createkeys'],
  }

  exec { 'createkeys':
    user    => $owner,
    cwd     => $keys_dir,
    command => 'eyaml createkeys',
    path    => $cmdpath,
    creates => $priv_key,
    require => Package['hiera-eyaml'],
  }

  file { $eyaml_files:
    ensure  => file,
    mode    => '0400',
    owner   => $owner,
    group   => $group,
    require => Exec['createkeys'],
  }
}
