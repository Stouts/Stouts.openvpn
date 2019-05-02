# Stouts.openvpn

[![Build Status](http://img.shields.io/travis/Stouts/Stouts.openvpn.svg?style=flat-square)](https://travis-ci.org/Stouts/Stouts.openvpn)
[![Galaxy](http://img.shields.io/badge/galaxy-Stouts.openvpn-blue.svg?style=flat-square)](https://galaxy.ansible.com/Stouts/openvpn/)

Ansible role that installs an openvpn server

* Install and setup OpenVPN server
* Create/revoke client's configurations and certificates
* Setup authentication with PAM (System, passwd files)

## Requirements

None. 

## Supported platforms

- Ubuntu 14.04
- Ubuntu 16.04
- Debian 8
- Debian 9
- Centos 7

## Variables

For a complete variable reference, see the [`defaults/main.yml`](defaults/main.yml) file.

## Example playbook

```yaml

- hosts: all
  vars:
    openvpn_use_pam: true
    openvpn_download_clients: true
    openvpn_download_dir: /home/me/Projects
    openvpn_clients: 
      - client1
      - client2
    openvpn_use_pam_users:
      - name: user1
        password: password1
      - name: user2
        password: password2
  roles:
    - Stouts.openvpn
```

## License

Licensed under the MIT License. See the LICENSE file for details.

## Feedback, bug-reports, requests, ...

...are [welcome](https://github.com/Stouts/Stouts.openvpn/issues)!
