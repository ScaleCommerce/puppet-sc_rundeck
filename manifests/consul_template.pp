class sc_rundeck::consul_template (
  $execuser = 'scjobs',
) {

  file { "/var/lib/rundeck/consul":
    path => '/var/lib/rundeck/consul',
    ensure => 'directory',
    owner  => 'rundeck',
    group  => 'rundeck',
    mode   => '750',
  }
  $rundeck_projects = hiera_hash('rundeck::projects', {})

  each($rundeck_projects) |$k, $v| {
    $project_name = $k

    if $project_name == "scalecommerce" {
      $execuser = "scjobs"
    }
    if $project_name == "" {
      $execuser = "scjobs"
    }

    file { "/var/lib/rundeck/consul/rundeck-resources-$project_name.ctmpl":
      owner   => 'rundeck',
      group   => 'rundeck',
      mode    => '750',
      content => template("${module_name}/rundeck-resources-consul.ctmpl.erb"),
      require => File["/var/lib/rundeck/consul"]
    }

    supervisord::program { "rundeck-node-consul-$project_name":
      command   => "/usr/local/bin/consul-template --template '/var/lib/rundeck/consul/rundeck-resources-$project_name.ctmpl:/var/lib/rundeck/projects/$project_name/etc/$project_name.xml'",
      user    => 'rundeck',
      require => File["/var/lib/rundeck/consul/rundeck-resources-$project_name.ctmpl"],
    }
  }
}
