# amazon-openvpn-ddns

## Input Variables
|Variable name|Description|Default|
|---|---|---|
|AWS_REGION|AWS Service Region to deploy|eu-west-2|
|prefix|Project Name|
|vpc_id|VPC ID|
|openvpn_server_ami|Any Ubuntu AMI (tested in eu-west-2 ubuntu 22.04 amd64)|
|subnet_id|Subnet ID that OpenVPN server will be deployed to|
|instance_type|OpenVPN Server Instance type|t2.small|
|admin_pwd|Admin Password for OpenVPN Server|
|email|Email to register ssl certificate for your `subdomain.domain`|
|subdomain|Subdomain, like prefix of `api.google.com`, it is `api`|
|domain|Domain, like `google.com`|
|public_key_openssh|Generate your ssh key and put public key here|

## How to Launch? 
1. Run terraform to deploy.
    ```terraform
    terraform init
    terraform apply -auto-approve
    ```
2. Change your hostname when you have access to `subdomain.domain/admin`.
    - Configuration -> Network Settings -> Hostname or IP Address -> Enter your `subdomain.domain`.

```mermaid
sequenceDiagram
  client->>route53: xxx.xxx.xxx vpn access
  route53->>client: public ip address
  box Aqua AWS
  participant openvpn access server(ec2)
  participant private subnet resources
  end
  client->>openvpn access server(ec2): ssh/vpn
  openvpn access server(ec2)->private subnet resources: 
  Note over openvpn access server(ec2),private subnet resources: Access
  loop Every day, Reboot
    openvpn access server(ec2)-->route53: Update IP
  end
```
