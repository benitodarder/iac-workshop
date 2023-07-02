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
  - name: operator
    passwd: $6$rounds=4096$11223344$.GkDCyqNv5UVJu6Er6Cb3L4fPqHCrOO3UYpZsyfPr/BFCz73CSRnE9b9SmBfNaUam5siTGIVG93Vf0GJRFt5z/
    primary_group: operator
    groups: operator
    sudo:
      - ALL=(ALL) NOPASSWD:ALL
    lock-passwd: false
    ssh_pwauth: true
    ssh-authorized-keys:
      - ssh-rsa key-0f0ffec9e2174f790
      
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
  - sed -i "s/^AllowUsers ec2-user/AllowUsers operator/g" /etc/ssh/sshd_config
  ## Services
  - [/usr/bin/systemctl, restart, sshd]
  - [/usr/bin/systemctl, daemon-reload]
  - touch /root/beenthere
