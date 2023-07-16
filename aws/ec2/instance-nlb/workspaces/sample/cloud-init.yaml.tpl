#cloud-config
package_upgrade: true

preserve_hostname: false
timezone: UTC

runcmd:
  - set -x
# (R)Enable password login
  - sed -i 's/^PasswordAuthentication\ no/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
  - [/usr/bin/systemctl, restart, sshd]
# Proof of execution
  - touch /root/instanceWasThere

