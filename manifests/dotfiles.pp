define python::dotfiles ( 
  $user               = $title,
  $home               = undef,
  $pypi_repos         = {},
  $pydistutils_config = {},
  $pip_config         = {},
){

  validate_hash($pypi_repos)
  validate_hash($pydistutils_config)
  validate_hash($pip_config)

  validate_string($user)
  
  $userhome = $home ? {
    nil     => "/home/${user}",
    default => $home,
  }

  File {
    owner => $user,
    group => $user,
    mode  => '0644',
  }

  if ! empty($pypi_repos) {
    file { "${userhome}/.pypirc":
      content => template('python/pypirc.erb'),
    }
  }

  if ! empty($pydistutils_config) {
    file { "${userhome}/.pydistutils.cfg":
      content => template('python/pydistutils.cfg.erb'),
    }
  }

  if ! empty($pip_config) {
    file { "${userhome}/.pip":
      ensure => 'directory',
      } ->
      file { "${userhome}/.pip/pip.conf":
        content  => template('python/pip_pip.conf.erb'),
      }
  }
}
