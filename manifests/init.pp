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
  Class['::rundeck::install'] -> Class['::rundeck::config::global::web']

}
