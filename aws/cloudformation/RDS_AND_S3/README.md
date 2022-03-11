# Build EC2, RDS, S3Bucket by AWS CloudFormation
### Intro
Use AWS CloudFormation's template for creating a stack with: 
- 1 VPC
- 3 Public Subnets
- 1 Public Internet Gateway
- 1 Public Route Table
- 1 Security Group
- 1 EC2 Instance
- 3 Private Subnets
- 1 RDS Parameter Group
- 1 RDS Security Group
- 1 RDS Subnet Group
- 1 RDS Instance
- 1 S3Bucket
- 1 IAM Role
- 1 IAM Policy
- 1 IAM Role Profile

### How to use
1. Install AWS CLI

2.  Configure profile of dev and demo account by command `aws configure --profile xxx`, or configure profiles by modifying files `config` and `credentials` in directory `~/.aws/`

3. Execute main shell script to create and delete stack resouces automatically 
    `sh aws-stack.sh`
    Enter necessary info according to tips displayed on the command line, please remind that most of them can be skipped as default value

### How to verify
- Launch your dev/demo account on AWS website
- Search keyword `cloudformation` on searching bar on the top left side
- find the stack you created or deleted

