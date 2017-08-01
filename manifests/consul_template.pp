class sc_rundeck::consul_template (
  $execuser = 'scjobs',
) {
  file { '/var/lib/rundeck/consul':
    ensure => 'directory',
    owner  => 'rundeck',
    group  => 'rundeck',
    mode   => '750',
  }->
  file { '/var/lib/rundeck/consul/rundeck-resources.ctmpl':
    owner   => 'rundeck',
    group   => 'rundeck',
    mode    => '750',
    content => template("${module_name}/rundeck-resources-consul.ctmpl.erb"),
  }

  $rundeck_projects = hiera_hash('rundeck::projects', {})

  each($rundeck_projects) |$k, $v| {
    $project_name = $v['resource_sources']['resources']['project_name']
    supervisord::program { "rundeck-node-consul-$k":
      command   => "/usr/local/bin/consul-template --template '/var/lib/rundeck/consul/rundeck-resources.ctmpl:/var/lib/rundeck/projects/$project_name/etc/resources.xml:supervisorctl restart rundeckd'",
      user    => 'rundeck',
      require => File['/var/lib/rundeck/consul/rundeck-resources.ctmpl'],
    }
  }

}