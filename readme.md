# Packer Hashicorp Debian 12

Personal deployment of Debian 12 on Proxmox with a little job ansible to create template.

## Usefull files for this project  

 - ansible : private key for ansible user
 
 - ansible.pub: prublic key for ansible user

 - id_rsa.pub: my personal public key for root

 - passvault.txt: file with password to decrypt vault file vault.yml

 - vault.yml: ansible-vault that contains some vars like root_password and ansible_passwork for the ansible job

 - variables.pkr.hcl: vars for packer job

    - urlprox: proxmox's url
    - username: user to connect with api Proxmox
    - password: password of the proxmox user
    - sshuser: ssh user before ansible job, use to configure the template
    - sshpass: ssh password before ansible job
    - tpl_address: ip address of template
    - tpl_netmask: network netmask
    - tpl_gtw: gateway's ip address
    - tpl_dns: dns server's ip address
    - tpl_domain: local domain name
