# == Class: hiera::params
#
# This class handles OS-specific configuration of the hiera module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hiera::params {
  if $::puppetversion =~ /Puppet Enterprise/ {
    $hiera_yaml = '/etc/puppetlabs/puppet/hiera.yaml'
    $backends   = { 'yaml' => { 'datadir' => '/etc/puppetlabs/puppet/hieradata' } }
    $eyaml_backend   = {'eyaml' => {'datadir'  => '/root/dev/bar', 'pkcs7_private_key'   => '/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem', 'pkcs7_public_key' =>'/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem'}}
    $owner      = 'pe-puppet'
    $group      = 'pe-puppet'
    $provider   = 'pe_gem'
    $cmdpath    = '/opt/puppet/bin'
    $confdir    = '/etc/puppetlabs/puppet'
  } else {
    $hiera_yaml = '/etc/puppet/hiera.yaml'
    $backends   = { 'yaml' => { 'datadir' => '/etc/puppet/hieradata' } }
    $eyaml_backend   = {'eyaml' => {'datadir'  => '/root/dev/bar', 'pkcs7_private_key'   => '/etc/puppet/keys/private_key.pkcs7.pem', 'pkcs7_public_key' =>'/etc/puppet/keys/public_key.pkcs7.pem'}}
    $owner      = 'puppet'
    $group      = 'puppet'
    $provider   = 'gem'
    #    $cmdpath    = '/usr/bin/puppet'
    $cmdpath    = '/usr/local/bin'
    $confdir    = '/etc/puppet'
  }
  $logger       = 'console'
  $no_backend   = ['yaml','file']
}
