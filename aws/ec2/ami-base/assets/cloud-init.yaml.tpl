#cloud-config
package_upgrade: true
preserve_hostname: false
timezone: UTC

users:
  - default
  - name: ssm-user
    primary_group: ssm-user
    groups: ssm-user
    sudo:
      - ALL=(ALL) NOPASSWD:ALL

packages:
  - git
  - amazon-efs-utils
  - nfs-utils

write_files:
  - content: |
      [default]
      region = ${region}
    path: /root/.aws/config


runcmd:
  ## Pre-tasks
  - set -x
  ## Remove users password expiration
  - passwd -x 99999 ssm-user
  ## Allow users
  - sed -i 's/^PasswordAuthentication\ no/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
  ## Services
  - [/usr/bin/systemctl, restart, sshd]
  - [/usr/bin/systemctl, daemon-reload]
