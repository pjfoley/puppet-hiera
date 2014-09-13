# == Class: hiera::backend::file
#
# This class installs and configures hiera-file
#
# === Authors:
#
# Peter Foley <peter@ifoley.id.au>
#
# === Copyright:
#
# Copyright (C) 2014 Peter Foley, unless otherwise noted.
#
class hiera::backend::file (
  $backends = undef,
  $provider = $hiera::params::provider,
  $owner    = $hiera::params::owner,
  $group    = $hiera::params::group,
  $cmdpath  = $hiera::params::cmdpath,
) inherits hiera::params {

  package { 'hiera-file':
    ensure   => installed,
    provider => $provider,
  }
}
