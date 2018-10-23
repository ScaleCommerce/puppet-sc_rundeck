# sc_rundeck

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with sc_nginx](#setup)
    * [What sc_rundeck affects](#what-sc_rundeck-affects)
    * [Beginning with sc_rundeck](#beginning-with-sc_rundeck)
4. [Usage - Configuration options and additional functionality](#usage)
4. [Testing with InSpec](#testing)

## Overview

ScaleCommerce Wrapper Module for puppet-rundeck module. Manages Supervisord and configuration by consul-template.

## Module Description

This module uses hiera to configure supervisord and rundeck. We're using upstream modules [voxpupuli/puppet-rundeck](https://github.com/voxpupuli/puppet-rundeck) and [ajcrowe/puppet-supervisord](https://github.com/ajcrowe/puppet-supervisord). This module is compatible with Ubuntu 14.04, Ubuntu 16.04, Puppet 3, Puppet 4, Puppet 5.

## Setup

### What sc_rundeck affects

* rundeckd
* supervisord


### Beginning with sc_rundeck

You will need a working hiera-Setup (https://docs.puppetlabs.com/hiera/3.1/complete_example.html).

Check out our solultion for Puppet-Hiera-Roles (https://github.com/ScaleCommerce/puppet-hiera-roles).

## Usage

Put this into your node.yaml or role.yaml. This module supports merging of configuration (i.e. vhosts) from all hierarchy levels.

```
---
classes:
  - sc_rundeck

```

Check out hiera config examples in [test/hiera/module.yaml](test/hiera/module.yaml)

## Testing

When making changes you can test this module locally with [gitlab-runner on Mac OSX](https://docs.gitlab.com/runner/install/osx.html)

``gitlab-runner exec docker --env "GIT_STRATEGY=none" --docker-volumes `pwd`:/builds/project-0 xenial:puppet5``

### InSpec

Configuration testing is done with `InSpec`: https://www.inspec.io/
