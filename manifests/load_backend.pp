define hiera::load_backend (
  $backends = undef,
  $owner    = $hiera::params::owner,
  $group    = $hiera::params::group,
) {
  validate_hash($backends)

  $backend_hash = hash_value($backends, $title)

  if defined( "hiera::backend::${title}") {
    class {"hiera::backend::${title}":
      backends => $backend_hash,
      owner    => $owner,
      group    => $group,
    }
  }
}
