Demo: Terraform with AWS
====
Provide a very simple AWS setup with an ec2 nginx webserver, which is managed by Terraform.

## General information

This demo setup provides a simple Terraform setup with AWS as cloud provider backend.
For more information about the AWS and the used Terraform provider aws, please take a look into the official documentations from [Terrafrom](https://www.terraform.io/docs/) and [AWS](https://aws.amazon.com/documentation/).

Note: The easiest way to use this demo is with installed aws-cli tools. You can found them [here](https://aws.amazon.com/cli/).

## Requirements

To use the demo you need Terraform, an existing AWS account and internet connection to the AWS universe.

## Demo Usage

Note: Please check your AWS account. You need the AWS credentials for the Terraform configuration.

Edit and configure your aws-cli environment or use the direct configuration in the `example.tf`.
Remove the beginning '#' and replace the placeholder in the configuration.

You have different options to direct configure the aws provider in your `example.tf`.
A refered file can provide all credentials (config parameter `shared_credentials_file`) or add your own credentials directly (config parameters: `access_key` and `secret_key`).
```
provider "aws" {
  region     = "us-west-2"
  #access_key = "INSERT AWS ACCESS KEY HERE"
  #secret_key = "INSERT AWS SECRET KEY HERE"
  #shared_credentials_file = "INSERT PATH TO THE FILE HERE"
}
```

Next step is to configure the SSH Keypair, which can be created and hosted directly at AWS or can be created and stored on your local machine.
Please adjust the values with your chosen method.

Note: The config parameter `public_key` needs to be an oneliner with the beginning encryption part like `ssh-rsa ...`.
```
resource "aws_key_pair" "example_demo_keypair" {
  key_name = "example-demo-keypair"
  #public_key = "FILL ME WITH CONTENT"
}
```

After all finished configuration work you can start to execute `terraform plan` to verify your demo setup.
```
terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but
will not be persisted to local or remote state storage.


The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ aws_instance.example
    ami:                         "ami-7c803d1c"
    associate_public_ip_address: "<computed>"
    availability_zone:           "<computed>"
    ebs_block_device.#:          "<computed>"
    ephemeral_block_device.#:    "<computed>"
    instance_state:              "<computed>"
    instance_type:               "t2.micro"
    key_name:                    "example-demo-keypair"
    network_interface_id:        "<computed>"
    placement_group:             "<computed>"
    private_dns:                 "<computed>"
    private_ip:                  "<computed>"
    public_dns:                  "<computed>"
    public_ip:                   "<computed>"
    root_block_device.#:         "<computed>"
    security_groups.#:           "<computed>"
    source_dest_check:           "true"
    subnet_id:                   "<computed>"
    tags.%:                      "1"
    tags.Name:                   "Terraform_demo_from_Datadrivers"
    tenancy:                     "<computed>"
    user_data:                   "686fdda7fa2fa6636c165e69e100e815b5d77ac4"
    vpc_security_group_ids.#:    "<computed>"

+ aws_key_pair.default_keypair
    fingerprint: "<computed>"
    key_name:    "example-demo-keypair"
    public_key:  "ssh-rsa xxxxxxxxxxxxxxxxxxxxxx"

+ aws_security_group.default
    description:                          "Used in the terraform demo"
    egress.#:                             "1"
    egress.482069346.cidr_blocks.#:       "1"
    egress.482069346.cidr_blocks.0:       "0.0.0.0/0"
    egress.482069346.from_port:           "0"
    egress.482069346.prefix_list_ids.#:   "0"
    egress.482069346.protocol:            "-1"
    egress.482069346.security_groups.#:   "0"
    egress.482069346.self:                "false"
    egress.482069346.to_port:             "0"
    ingress.#:                            "2"
    ingress.2214680975.cidr_blocks.#:     "1"
    ingress.2214680975.cidr_blocks.0:     "0.0.0.0/0"
    ingress.2214680975.from_port:         "80"
    ingress.2214680975.protocol:          "tcp"
    ingress.2214680975.security_groups.#: "0"
    ingress.2214680975.self:              "false"
    ingress.2214680975.to_port:           "80"
    ingress.2541437006.cidr_blocks.#:     "1"
    ingress.2541437006.cidr_blocks.0:     "0.0.0.0/0"
    ingress.2541437006.from_port:         "22"
    ingress.2541437006.protocol:          "tcp"
    ingress.2541437006.security_groups.#: "0"
    ingress.2541437006.self:              "false"
    ingress.2541437006.to_port:           "22"
    name:                                 "terraform_example_sg"
    owner_id:                             "<computed>"
    vpc_id:                               "<computed>"


Plan: 3 to add, 0 to change, 0 to destroy.

```

If everything goes right, you can apply your demo on the AWS cloud with `terraform apply`.

```
terraform apply

aws_key_pair.default_keypair: Creating...
  fingerprint: "" => "<computed>"
  key_name:    "" => "example-demo-keypair"
  public_key:  "" => "ssh-rsa xxxxxxxxxxxxxxxxxxxx"
aws_security_group.default: Creating...
  description:                          "" => "Used in the terraform demo"
  egress.#:                             "" => "1"
  egress.482069346.cidr_blocks.#:       "" => "1"
  egress.482069346.cidr_blocks.0:       "" => "0.0.0.0/0"
  egress.482069346.from_port:           "" => "0"
  egress.482069346.prefix_list_ids.#:   "" => "0"
  egress.482069346.protocol:            "" => "-1"
  egress.482069346.security_groups.#:   "" => "0"
  egress.482069346.self:                "" => "false"
  egress.482069346.to_port:             "" => "0"
  ingress.#:                            "" => "2"
  ingress.2214680975.cidr_blocks.#:     "" => "1"
  ingress.2214680975.cidr_blocks.0:     "" => "0.0.0.0/0"
  ingress.2214680975.from_port:         "" => "80"
  ingress.2214680975.protocol:          "" => "tcp"
  ingress.2214680975.security_groups.#: "" => "0"
  ingress.2214680975.self:              "" => "false"
  ingress.2214680975.to_port:           "" => "80"
  ingress.2541437006.cidr_blocks.#:     "" => "1"
  ingress.2541437006.cidr_blocks.0:     "" => "0.0.0.0/0"
  ingress.2541437006.from_port:         "" => "22"
  ingress.2541437006.protocol:          "" => "tcp"
  ingress.2541437006.security_groups.#: "" => "0"
  ingress.2541437006.self:              "" => "false"
  ingress.2541437006.to_port:           "" => "22"
  name:                                 "" => "terraform_example_sg"
  owner_id:                             "" => "<computed>"
  vpc_id:                               "" => "<computed>"
aws_key_pair.default_keypair: Creation complete
aws_security_group.default: Creation complete
aws_instance.example: Creating...
  ami:                               "" => "ami-7c803d1c"
  associate_public_ip_address:       "" => "<computed>"
  availability_zone:                 "" => "<computed>"
  ebs_block_device.#:                "" => "<computed>"
  ephemeral_block_device.#:          "" => "<computed>"
  instance_state:                    "" => "<computed>"
  instance_type:                     "" => "t2.micro"
  key_name:                          "" => "example-demo-keypair"
  network_interface_id:              "" => "<computed>"
  placement_group:                   "" => "<computed>"
  private_dns:                       "" => "<computed>"
  private_ip:                        "" => "<computed>"
  public_dns:                        "" => "<computed>"
  public_ip:                         "" => "<computed>"
  root_block_device.#:               "" => "<computed>"
  security_groups.#:                 "" => "<computed>"
  source_dest_check:                 "" => "true"
  subnet_id:                         "" => "<computed>"
  tags.%:                            "" => "1"
  tags.Name:                         "" => "Terraform_demo_from_Datadrivers"
  tenancy:                           "" => "<computed>"
  user_data:                         "" => "686fdda7fa2fa6636c165e69e100e815b5d77ac4"
  vpc_security_group_ids.#:          "" => "1"
  vpc_security_group_ids.4247570526: "" => "sg-xxxxxxxxx"
aws_instance.example: Still creating... (10s elapsed)
aws_instance.example: Still creating... (20s elapsed)
aws_instance.example: Creation complete

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

public dns = ec2-xxxxxxxxxxx.us-west-2.compute.amazonaws.com
public ip = 1.2.3.4
```

The last lines display the external ip address and dns of your demo instance.

To verify your results , please open a browser and type `http://<PUBLIC DNS>` or type in your shell `ssh -l ubuntu <PUBLIC IP>`.
The webserver will answer with the nginx default html page and on the ssh connection you will see the bash prompt of the system.

To show the output without a full run of `terraform plan`, type `terraform output` in your shell (but it needs an existing terraform state file).
```
terraform output

public dns = ec2-xxxxxxxxxxx.us-west-2.compute.amazonaws.com
public ip = 1.2.3.4
```


