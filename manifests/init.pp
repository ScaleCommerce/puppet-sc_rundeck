class sc_rundeck (
  $use_supervisor = true,
) {

  if $use_supervisor {
    class {'::sc_rundeck::supervisor':}
  }

  class {'::sc_rundeck::consul_template':}

  include sc_java
  include rundeck

  Class['sc_java'] -> Class['::rundeck::install']

  if versioncmp( $rundeck::package_ensure, '3.0.0' ) < 0 {
    Class['::rundeck::install'] -> Class['::rundeck::config::global::web']
  }
  
  file { "/etc/rundeck/sc_realm.properties":
    content => template("${module_name}/realm.properties.erb"),
  }

}
