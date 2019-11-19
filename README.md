# Stouts.openvpn

[![Build Status](http://img.shields.io/travis/Stouts/Stouts.openvpn.svg?style=flat-square)](https://travis-ci.org/Stouts/Stouts.openvpn)
[![Galaxy](http://img.shields.io/badge/galaxy-Stouts.openvpn-blue.svg?style=flat-square)](https://galaxy.ansible.com/Stouts/openvpn/)

Ansible role that installs an openvpn server

* Install and setup OpenVPN server
* Setup authentication

## Updating from 2.x versions of the role

In version 3.0.0, EasyRSA integration has been removed from the role. To
generate keys and certificates you will need to use a separate role. This role
will expect the keys and certificates to be placed in an EasyRSA PKI. Updating
should be straightforward.

For instance, using [this easyrsa
role](https://github.com/nkakouros-original/ansible-role-easyrsa), the following
playbook:


```yaml
openvpn_key_country: SE
openvpn_key_province: Stockholm
openvpn_key_city: Stockholm
openvpn_key_org: KTH
openvpn_key_email: test@email.com
openvpn_key_size: 1024
openvpn_keydir: "{{ easyrsa_pki_dir }}"
openvpn_download_clients: true
openvpn_download_dir: "/home/vpn-credentials/"
openvpn_use_pam: false
openvpn_client_to_client: false
openvpn_topology: subnet
openvpn_clients:
  - client1
  - client2
openvpn_client_options:
  - link-mtu 1460
openvpn_server_options:
  - duplicate-cn
  - management localhost 7505
openvpn_client_config_dir: /etc/openvpn/client
```

will need to be translated to:

```yaml
# EasyRSA
easyrsa_conf_req_country: SE
easyrsa_conf_req_province: Stockholm
easyrsa_conf_req_city: Stockholm
easyrsa_conf_req_org: KTH
easyrsa_conf_req_email: test@email.com
easyrsa_conf_key_size: 1024
easyrsa_generate_dh: true
easyrsa_servers:  # note that the server needs to be set explicitly
  - server
easyrsa_clients: >-
  [
    {%- for i in range(1, world_reuse | int + 2) -%}
      '{{ inventory_hostname + '-s' + i | string }}',
    {% endfor -%}
  ]
easyrsa_pki_dir: /etc/easyrsa/pki

# OpenVPN
openvpn_keydir: "{{ easyrsa_pki_dir }}"
openvpn_download_clients: true
openvpn_download_dir: "/home/vpn-credentials/"
openvpn_use_pam: false
openvpn_client_to_client: false
openvpn_topology: subnet
openvpn_clients: "{{ easyrsa_clients }}"
openvpn_client_options:
  - link-mtu 1460
openvpn_server_options:
  - duplicate-cn
  - management localhost 7505
openvpn_ccd: /etc/openvpn/client
```

Another change that you might need to consider is that the variable
`openvpn_client_config_dir` has been renamed to `openvpn_ccd`. A new variable
`openvpn_ccd_configs` allows the creation of client-specific configuration
files.

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
