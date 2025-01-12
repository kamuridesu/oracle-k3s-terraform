# Oracle VMs with Terraform/OpenTofu
The configuration of the VMs on the Oracle Cloud Infrastructure is done with Terraform/OpenTofu configs. This ensures that the configuration is reproducible and consistent.

The config consists of three VMs:

- Control plane node
- Agent node
- Load Balancer

Each VM has one objective. The control planes and agent nodes are for K3S, the load balancer node is our networking entrypoint. But we can't allow access to all VMs from any endpoint, so we need to setup our networking with different scopes for each config.

I ended up using two VCN, one for the Load Balancer and one for the K3S VMs. They communicate with each other by a remote peering connection using a dynamic routing gateway attached to their VCN and added to the routing table. Then, to limit networking scopes, I used a security list.

For the Load Balancer we can allow ingress and egress from any endpoint. It'll only run HAProxy anyway so no worries. For the K3S VM, it has a much more limite scope, allowing traffic only from the Load Balancer and my public IP.

# Setup
You need your fingerprint, private key file, tenancy and user OCID, region and compartment_id. Just fill all variables with a TFVars config or TF_VAR environment variables.

After that, provide your private key path and run the command `terraform plan`. This commands generates a plan that describes the changes that Terraform/OpenTofu may apply to your environment.
If you don't see any problems, just run `terraform apply`, if you've added your variables to a TFVars file, you also need to use the `-var-file=` argument to point Terraform/OpenTofu to use that config file.
After that another plan will be present to you and you will be prompted to accept that plan and apply the config or stop. If you want to go ahead, just type `yes` and the configuration will be applied.
