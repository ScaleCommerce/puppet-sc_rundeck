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

GitLab runner is activated to test after each push.

### InSpec

Configuration testing is done with `InSpec`: https://www.inspec.io/

### Local testing

To test changes before committing them, you can execute the gitlab runner locally.
Unfortunately the official gitlab-runner does not support local testing (according feature request: https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/issues/1359). So we need a custom binary:

1. install docker

2. download gitlab-runner binary

```bash
sudo curl --output /usr/local/bin/gitlab-ci-multi-runner-sc https://gitlab.scale.sc/a.kirchner/gitlab-ci-multi-runner-sc/raw/master/bin/gitlab-ci-multi-runner-sc
sudo chmod +x /usr/local/bin/gitlab-ci-multi-runner-sc
```

3. execute in your working copy

```bash
gitlab-ci-multi-runner-sc exec docker --docker-volumes `pwd`:/tmp/local-working-directory <TEST>
```

The following tests are available:

`14.04:puppet3`

`16.04:puppet3`

`14.04:puppet4`

`16.04:puppet4`

