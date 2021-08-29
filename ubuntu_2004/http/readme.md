# [NoCloud](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html#datasource-nocloud)

Use the host workstation as source for cloud-init `user-data` and `meta-data`.
Files must be named `user-data` and `meta-data`.
Both files are required to be present for it to be considered a valid seed ISO.

The path to these files is interpreted in the Packer json's `"http_directory": "ubuntu_2004/http"`
