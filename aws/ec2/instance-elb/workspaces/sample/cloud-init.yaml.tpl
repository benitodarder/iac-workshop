#cloud-config
package_upgrade: true

preserve_hostname: false
timezone: UTC

runcmd:
  - touch /root/instanceWasThere

