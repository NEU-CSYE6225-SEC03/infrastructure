# Build private cloud with AWS CloudFormation
### Intro
    Use AWS CloudFormation's template for creating a stack with 1-VPC, 3-Subnets, 1-IGW, 1-RT

### How to use
- Install AWS CLI
- Configure profile of dev and demo account by command `aws configure --profile xxx`, or configure profiles by modifying files `config` and `credentials` in directory `~/.aws/`
- Execute main shell script to create and delete stack resouces automatically
```
sh aws-stack.sh
```
Enter necessary info according to tips displayed on the command line, most of them can be skipped as default value

### How to verify
- Launch your dev/demo account on AWS website
- Search keyword `cloudformation` on searching bar on the top left side
- find the stack you created or deleted

