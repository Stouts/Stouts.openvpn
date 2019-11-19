# Stouts.openvpn

[![Build Status](http://img.shields.io/travis/Stouts/Stouts.openvpn.svg?style=flat-square)](https://travis-ci.org/Stouts/Stouts.openvpn)
[![Galaxy](http://img.shields.io/badge/galaxy-Stouts.openvpn-blue.svg?style=flat-square)](https://galaxy.ansible.com/Stouts/openvpn/)

Ansible role that installs an openvpn server

* Install and setup OpenVPN server
* Setup authentication

## Requirements

Previous versions of the role supported generating certificates and keys for the
OpenVPN server to use. Since version 3.0.0, such support has been removed and
the users of the role are expected to use some other way of generating
certificates/keys (eg using another Ansible role). See the example playbook for
an example.

An EasyRSA role that was created specifically to compliment this role can be
found [here](https://github.com/nkakouros-original/ansible-role-easyrsa).

## Supported platforms

- Ubuntu 14.04
- Ubuntu 16.04
- Ubuntu 18.04
- Debian 8
- Debian 9
- Centos 7

## Variables

See [defaults/main.yml](defaults/main.yml) for a full list of variables together
with documentation on how to use them to configure this role.

## Example playbook

See [molecule/default/playbook.yml](molecule/default/playbook.yml) for a working
example of how to use this role.


## License

Licensed under the MIT License. See the LICENSE file for details.

## Feedback, bug-reports, requests, ...

...are [welcome](https://github.com/Stouts/Stouts.openvpn/issues)!
