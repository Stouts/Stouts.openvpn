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

## Elastic Beats from monitoring
### Heartbeat monitor

The role comes bundled with a [meta/monitors.yml](meta/monitors.yml) template
that can be used by [Heartbeat](https://www.elastic.co/products/beats/heartbeat)
to check if the OpenVPN server is up and running.  The template can be
configured via variables (they should be self-explanatory). To use it, you can
use some Ansible tasks to upload it to your Heartbeat instance. For example:

```yaml
- name: Add earth-kibana host
  add_host:
    name: heartbeat_instance
    hostname: "{{ heartbeat.hostname }}"
    ansible_host: "{{ heartbeat.ansible_host }}"
    ansible_password: "{{ heartbeat.ansible_password }}"
    ansible_user: "{{ heartbeat.ansible_user }}"

- name: Upload role monitors
  template:
    src: "{{ item.1 + '/' + item.0 }}/meta/monitors.yml"
    dest: "/etc/heartbeat/monitors.d/{{ inventory_hostname }}.{{ item.0.split('.')[-1] }}.yml"
  when: (item.1 + '/' + item.0 + '/meta/monitors.yml') is file
  loop: "{{ roles | product(lookup('config', 'DEFAULT_ROLES_PATH')) | list }}"
  delegate_to: heartbeat_instance
```

### Filebeat input

The role also includes a filebeat input file that can be uploaded to a filebeat
server. The input reads the OpenVPN log and reads the lines that correspond to
successful connections. The role includes an Elasticsearch ingest pipeline that
can be imported to Elasticsearch to parse and break the log lines into fields.
The files can be found under the `meta/` folder.

## Example playbook

See [molecule/default/playbook.yml](molecule/default/playbook.yml) for a working
example of how to use this role.


## License

Licensed under the MIT License. See the LICENSE file for details.

## Feedback, bug-reports, requests, ...

...are [welcome](https://github.com/Stouts/Stouts.openvpn/issues)!
