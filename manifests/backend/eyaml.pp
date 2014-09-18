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
  $backends            = $hiera::params::eyaml_backends,
  $provider            = $hiera::params::provider,
  $private_key_content = undef,
  $public_key_content  = undef,
  $owner               = $hiera::params::owner,
  $group               = $hiera::params::group,
  $cmdpath             = undef,
) inherits hiera::params {

  if $cmdpath { validate_absolute_path($cmdpath) }
  validate_hash($backends)

  $priv_key = extract_hashvalues($backends, 'pkcs7_private_key')
  $pub_key = extract_hashvalues($backends, 'pkcs7_public_key')
  $eyaml_files = extract_hashvalues($backends, ['pkcs7_private_key', '[pkcs7_public_key'])
  $keys_dir = keysdir($priv_key[0])

  if ! $cmdpath {
    $cmdpath = findeyamlcmdpath()
  }

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
  }

  if $private_key_content {
      file { $priv_key:
        ensure  => file,
        content => $private_key_content,
        mode    => '0400',
        owner   => $owner,
        group   => $group,
        require => File['eyaml_keys.dir'],
      }
      file { $pub_key:
        ensure  => file,
        content => $public_key_content,
        mode    => '0400',
        owner   => $owner,
        group   => $group,
        require => File['eyaml_keys.dir'],
      }
  }
  else {
    File['eyaml_keys.dir']
    {
      before => Exec['createkeys'],
    }
      exec { 'createkeys':
        cwd       => $keys_dir,
        command   => 'eyaml createkeys',
        path      => $cmdpath,
        creates   => $priv_key,
        logoutput => true,
        require   => Package['hiera-eyaml'],
      }

      file { $eyaml_files:
        ensure  => file,
        mode    => '0400',
        owner   => $owner,
        group   => $group,
        require => Exec['createkeys'],
      }
  }
}
