#!/bin/bash

podman login registry.redhat.io

ansible-builder create

cp {certs.pem,containers.conf,podman-containers.conf,registries.conf} context/
cp mycontainerfile context/Containerfile

echo "Run podman build -f context/Containerfile -t ee_ocp_tools:1.? context"
