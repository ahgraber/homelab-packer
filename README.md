# Create vSphere VM Templates with Packer

Use [Packer](https://www.packer.io) to create VM templates for VMWare ESXi.
Images can be [used with terraform](https://github.com/ahgraber/homelab-terraform) to bootstrap a
[k3s cluster](https://github.com/ahgraber/homelab-gitops-k3s)

This repo builds 3 images, initially set up using `cloud-init` and then further customized using scripts during packer provisioning:

* `ubuntu_2004-docker`: ubuntu 20.04 LTS with docker installed and some other standard packages (see [cloud-init](./templates/user-data) for details)
* `ubuntu_2004-k8s-nodhcp`: ubuntu_2004-docker image with iscsi packages set up and all netplan configurations removed
* `ubuntu_2004-k8s-cloudinit-ready`: ubuntu_2004-k8s-nodhcp with cloud-init cleaned and ready for re-initialization

## [Preparation](docs/1%20-%20prerequisites.md)

## [Customization & Use](docs/2%20-%20packer.md)

## Quickstart

1. Update templates
2. Update json files with data from `.envrc` (assuming `.envrc` is complete)

   ```zsh
   # reload all env variables
   direnv allow .

   # perform substitutions
   envsubst < ./templates/variables.json >! ./variables.json
   envsubst < ./templates/user-data >! ./ubuntu_2004/http/user-data
   envsubst < ./templates/meta-data >! ./ubuntu_2004/http/meta-data
   ```

3. Build all images (including push to ESXi vSphere):

   ```sh
   for IMAGE in $(find . -name "ubuntu*.json"); do
     # packer build -force -var-file=variables.json ${IMAGE}
     packer build -var-file=variables.json ${IMAGE}
   done
   ```

## Notes

This creates 4 different machine images:

1. `ubuntu-2004` -- standard image, has simple IPv4 DHCP enabled
2. `ubuntu-2004-nodhcp` -- standard image with `/etc/netplan` cleared. Must provide netplan config to get internet
3. `ubuntu-2004-cloudinit` -- standard image with cloudinit-guestinfo configured for vSphere
4. `ubuntu-2004-cloudinit-guestinfo` -- image with cloudinit-guestinfo configured for vSphere and `/etc/netplan` cleared - must provide netplan config.

## References

- [David-VTUK's Rancher-Pakcer](https://github.com/David-VTUK/Rancher-Packer)
- [Nick Charlton - Automating Ubuntu 2004 with Packer](https://nickcharlton.net/posts/automating-ubuntu-2004-installs-with-packer.html)
- [BeryJu - Automating Ubuntu 2004 with Packer](https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer)
- [Mile's Gray's series with Ubuntu and K8s](https://blah.cloud/kubernetes/creating-an-ubuntu-18-04-lts-cloud-image-for-cloning-on-vmware/)
