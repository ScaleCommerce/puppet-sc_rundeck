class sc_rundeck::supervisor {

  include supervisord
  include rundeck

  file {  ['/etc/init/rundeckd.conf', '/etc/init.d/rundeckd']:
    ensure  => absent,
    require => Package['rundeck'],
  }

  if !defined(File['/etc/supervisor.init']) {
    file { '/etc/supervisor.init':
      ensure => directory,
    }
  }

  file { '/etc/supervisor.init/rundeckd':
    owner   => 'rundeck',
    group   => 'rundeck',
    mode    => '750',
    content => template("${module_name}/rundeck.supervisor.init.erb"),
    require => [File['/etc/supervisor.init'],Package[rundeck]],
  }

  supervisord::program { 'rundeckd':
    command   => '/etc/supervisor.init/rundeckd',
    user      => 'rundeck',
    program_environment => { 'HOME' => '/var/lib/rundeck', 'USER' => 'rundeck' },
    autostart   => true,
    autorestart => true,
    require     => File['/etc/supervisor.init/rundeckd'],
    before      => Service['rundeckd'],
  }~>

  exec {'rundeckd_reload':
    command   => '/usr/local/bin/supervisorctl restart rundeckd',
    refreshonly => true,
    require     => Service['rundeckd'],
  }

  # override default service provider
  Service <| title == "rundeckd"|> {
    provider => supervisor,
  }
}
