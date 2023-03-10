# Custom_Ansible_EE

Ensure you run this on the controller, and ensure you have the following options:
```
[root@aap ~]# cat /var/lib/awx/venv/awx/lib/python3.9/site-packages/awx/settings/defaults.py | grep privileged
DEFAULT_CONTAINER_RUN_OPTIONS = ['--privileged','--network', 'slirp4netns:enable_ipv6=true']
from: https://github.com/sean-m-sullivan/ee_definition_config#running-this-on-a-container
```

Followed instructions from:
https://www.ansible.com/blog/the-anatomy-of-automation-execution-environments

Ensure you have the following file:
execution-environment.yml 
requirements.txt
requirements.yml
bindep.txt

with the following content:
```
[root@aap custom_ansible_ee]# cat requirements.yml 
---
collections:
  - awx.awx
  - community.general
  - community.kubernetes
[root@aap custom_ansible_ee]# cat requirements.txt 
[root@aap custom_ansible_ee]# cat bindep.txt 
git [platform:rpm]
skopeo [platform:rpm]
podman [platform:rpm]
[root@aap custom_ansible_ee]# cat execution-environment.yml 
---
version: 1
build_arg_defaults:
  EE_BASE_IMAGE: 'registry.redhat.io/ansible-automation-platform-23/ee-minimal-rhel8:latest'
  EE_BUILDER_IMAGE: 'registry.redhat.io/ansible-automation-platform-23/ansible-builder-rhel8:latest'

dependencies:
  galaxy: requirements.yml
  python: requirements.txt
  system: bindep.txt

```
Then run:
```
ansible-builder create
```
It will create a context directory with the following structure:

```
[root@aap custom_ansible_ee]# ansible-builder create
Complete! The build context can be found at: /root/workdir/custom_ansible_ee/context
[root@aap custom_ansible_ee]# tree ./context/
./context/
├── _build
│   ├── bindep.txt
│   ├── requirements.txt
│   └── requirements.yml
└── Containerfile

1 directory, 4 files
```
Copy configs and certs:
```
cp {certs.pem,containers.conf,podman-containers.conf,registries.conf} context/
```
Then copy an existing copy of Containerfile:
```
[root@aap custom_ansible_ee]# cp mycontainerfile context/Containerfile 
cp: overwrite 'context/Containerfile'? y
```
Then run this:
```
podman build -f context/Containerfile -t ee_ocp_tools:1.3 context
```
