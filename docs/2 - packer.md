# Create VM Templates with Packer

## Customization

1. Add packer files to `.gitignore`

   ```sh
   cat << EOF >> .gitignore
   .env
   .envrc

   *.zip
   *.ova

   *.json
   http/
   packer_cache/

   !templates/*

   EOF
   ```

2. [Install packer](https://learn.hashicorp.com/tutorials/packer/getting-started-install)

3. Update `.envrc` with secrets

   ```sh
   # these variables should be known from VCSA installation
   cat << EOF >> .envrc
   # vars for govc
   export GOVC_INSECURE=1
   export GOVC_URL="vsphere-ip-or-hostname"
   export GOVC_HOST_IP="10.2.2.1"
   export GOVC_USERNAME="administrator@example.com"
   export GOVC_PASSWORD="changeme"
   export GOVC_DATACENTER="Homelab"

   # vars for variables.template substitution
   export GOVC_CLUSTER="Cluster"
   export GOVC_DATASTORE=""
   export GOVC_FOLDER=""
   export GOVC_NETWORK=""
   export GOVC_RESOURCE_POOL=""

   export VM_USER=""
   export VM_PASS=""

   EOF
   ```

   ```sh
   direnv allow .
   cat << EOF >> .envrc
   export CRYPTED PASS="$(openssl passwd -1 "${VM_PASS})"
   export ID_KEY="$(cat ~/.ssh/ahg_ninerealmlabs_id_rsa.pub)"

   EOF
   ```

4. Update [variables](./../templates/variables.json)

5. Update [user-data](./templates/user-data) as needed. These must match the [ubuntu autoinstall reference](https://ubuntu.com/server/docs/install/autoinstall-reference)

   Of particular interest:

   - User account info and ssh keys
   - Packages
   - Customization scripts and preparation commands

6. Run `envsubst` on the template files

   ```zsh
   # reload all env variables
   direnv allow .

   # perform substitutions
   envsubst < ./templates/variables.json >! ./variables.json
   envsubst < ./templates/user-data >! ./ubuntu_2004/http/user-data
   envsubst < ./templates/meta-data >! ./ubuntu_2004/http/meta-data
   ```

7. Build image(s) (auto push to ESXi vSphere):

   Single image:

   ```sh
   packer build -var-file=variables.json ubuntu-{VERSION}.json
   ```

   All images:

   ```sh
   for IMAGE in $(find . -name "ubuntu*.json"); do
     # packer build -force -var-file=variables.json ${IMAGE}
     packer build -var-file=variables.json ${IMAGE}
   done
   ```

## Debugging

- If error, may have to edit _ubuntu-##.json_ with current MD5/SHAsum and iso URL

To debug building image from vsphere console:

- Use `Alt + F2` to get a working console when the installer failed or got stuck
- Review `/var/log/installer/subiquity-debug.log` check network configuration
- Review `/var/log/syslog` to debug the YAML parsing issues around the late-commands

## cloud-init / cloud-config references

- [Ubuntu AutoInstall Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [VMWare Cloudinit GuestInfo](https://github.com/vmware/cloud-init-vmware-guestinfo)
- [David-VTUK's Rancher-Pakcer](https://github.com/David-VTUK/Rancher-Packer)
- [Nick Charlton - Automating Ubuntu 2004 with Packer](https://nickcharlton.net/posts/automating-ubuntu-2004-installs-with-packer.html)
- [BeryJu - Automating Ubuntu 2004 with Packer](https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer)
- [Mile's Gray's series with Ubuntu and K8s](https://blah.cloud/kubernetes/creating-an-ubuntu-18-04-lts-cloud-image-for-cloning-on-vmware/)
