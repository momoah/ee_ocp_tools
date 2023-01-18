# Custom_Ansible_EE

Followed instructions from:
https://www.ansible.com/blog/the-anatomy-of-automation-execution-environments

Run:
# ansible-builder build  -t ee_ocp_tools:1.0
OR
# podman build -f context/Containerfile -t ee_ocp_tools:1.0 context
To explore the execution environment image:

ansible-navigator images -m interactive -pp never --eei localhost/ee_ocp_tools:1.0
