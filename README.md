# aws-infra

Configuration set of VPC assets in Dev and Demo environment.

### About
Use Terraform for Infrastructure as Code. Set up a Virtual Private Cloud (VPC) in AWS with the accompanying systems administration assets:

- 3 public subnets and 3 private subnets, each in an alternate accessibility zone in a similar locale in a similar VPC
- A  Internet Gateway asset connected to the VPC
- A public route table with all public subnets joined to it
- A private route table with all private subnets joined to it
- A public route in the public course table with the objective CIDR block 0.0.0.0/0 and the web door made above as the objective.
- An EC2 occurrence which will be sent off in the VPC made by the Terraform layout. The EC2 example won't be sent off in the default VPC.
- An EC2 security group (Application) for your EC2 examples that will have web applications. Add entrance rule to permit TCP traffic on ports 22, 443, and port on which your application runs from anyplace.
- An EC2 security group (Information base) for your RDS examples. Add entrance rule to permit TCP traffic on the port 3306 for MySQL/MariaDB or 5432 for PostgreSQL.
- A S3 pail with a haphazardly produced name. A lifecycle strategy for the pail to progress objects from STANDARD capacity class to STANDARD_IA  storage class following 30 days
- A RDS boundary gathering to match your data set (Postgres or MySQL) and its adaptation. Then RDS DB occasion utilizes the new parameter group and not the default  group.
- EC2 instance ought to be sent off with client information which incorporates Database username, secret phrase, hostname, and S3 pail name
- An IAM Policy WebAppS3 that will permit EC2 examples to perform S3 pails. This is expected for applications on your EC2 instance to converse with the S3 can.
- An IAM role for the EC2 administration and the WebAppS3 strategy is joined to it. This role is joined to your EC2 occurrence.


### Prerequisites

- `Terraform` [[link](https://developer.hashicorp.com/terraform/downloads?ajs_aid=fabfcbfb-08e9-498d-ac4b-fb1011298861&product_intent=terraform)]
- `AWS CLI` [[link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)]
- An AWS IAM account with access keys set up to create VPCs

### How to run?

1. Clone the repository from Organization
    ```shell
      git clone git@github.com:CloudCourseOrg/aws-infra.git
    ```
2. In the command line, navigate to the directory where the vpc.tf file is located

3. Place terraform.tfvars.demo file in this directory

4. Initialize the Terraform configuration file
    ```shell
      terraform init
    ```
5. Preview of the resources that will be created.
    ```shell
      terraform plan 
    ```
6. Format the files
    ```shell
      terraform fmt --recursive
    ```
7. Create the resources.
    ```shell
      terraform apply
    ```
8. If you want to delete the resources, run the following command
    ```shell
      terraform destroy
    ```

CLi command to add ssl certificate details ---- <br/><br/>
 <b>aws acm import-certificate --certificate C:/Users/arpit/Downloads/demo_arpitsamsung.me/demo_arpitsamsung_me.crt --certificate-chain demo_arpitsamsung_me.ca-bundle --private-key C:/Users/arpit/Downloads/demo_arpitsamsung.me/privateKey.txt --profile demo<b>
 <br/>
 <br/>

If you want to contact with me you can reach me at jain.arpit@northeastern.edu

Thanks Arpit Jain NU ID : 002771928
