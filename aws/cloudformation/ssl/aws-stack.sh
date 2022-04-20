echo "Use dev or demo AWS account?"
echo "Enter(dev / demo):"
read account
if [ "$account" != "dev" ] && [ "$account" != "demo" ]
then
    echo "Failed: enter a account"
    exit
fi

echo "Enter path of cloudformation file path(default: csye6225-infra.json):"
read templatePath
if [ -z "$templatePath" ]; then
    templatePath="csye6225-infra.json"
fi

echo "Enter a stack name:"
read stackName
if [ -z "$stackName" ]
then
    echo "Failed: enter a stack name"
    exit
fi

echo "Do you want to create or delete this stack?"
echo "Enter(create / delete):"
read stackOp
if [ "$stackOp" != "create" ] && [ "$stackOp" != "delete" ]
then
    echo "Failed: unknown operation on stack"
    exit
fi

# delete stack
if [ "$stackOp" == "delete" ]
then
    aws cloudformation describe-stacks --stack-name $stackName --profile $account &> /dev/null

    if [ $? -ne 0 ];then
    	echo "Failed: stack by this name may not exist"
    	exit
    fi

    aws cloudformation delete-stack --stack-name $stackName --profile $account
    echo "Deleted successfully"
    exit
fi

# create stack
aws cloudformation describe-stacks --stack-name $stackName --profile $account &> /dev/null

if [ $? -eq 0 ]
then
	echo "Failed: stack by this name already exist"
	exit
fi

# parameters
echo "Enter VPC NAME(default: vpc-test):"
read vpcName
if [ -z "$vpcName" ]
then
    vpcName="vpc-test"
fi

echo "Enter InternetGateWay NAME(default: igw-test):"
read igwName
if [ -z "$igwName" ]
then
    igwName="igw-test"
fi

echo "Enter RouteTable NAME(default: rt-test):"
read rtName
if [ -z "$rtName" ]
then
    rtName="rt-test"
fi

echo "Enter VPC CIDR(default: 199.0.0.0/16):"
read vpcCidr
if [ -z "$vpcCidr" ]
then
    vpcCidr="199.0.0.0/16"
fi

echo "Enter public subnet1 CIDR(default: 199.0.0.0/24):"
read subnetCidr1
if [ -z "$subnetCidr1" ]
then
    subnetCidr1="199.0.0.0/24"
fi

echo "Enter public subnet2 CIDR(default: 199.0.1.0/24):"
read subnetCidr2
if [ -z "$subnetCidr2" ]
then
    subnetCidr2="199.0.1.0/24"
fi

echo "Enter public subnet3 CIDR(default: 199.0.2.0/24):"
read subnetCidr3
if [ -z "$subnetCidr3" ]
then
    subnetCidr3="199.0.2.0/24"
fi

echo "Enter private subnet4 CIDR(default: 199.0.3.0/24):"
read subnetCidr4
if [ -z "$subnetCidr4" ]
then
    subnetCidr4="199.0.3.0/24"
fi

echo "Enter private subnet5 CIDR(default: 199.0.4.0/24):"
read subnetCidr5
if [ -z "$subnetCidr5" ]
then
    subnetCidr5="199.0.4.0/24"
fi

echo "Enter private subnet6 CIDR(default: 199.0.5.0/24):"
read subnetCidr6
if [ -z "$subnetCidr6" ]
then
    subnetCidr6="199.0.5.0/24"
fi

echo "Enter private subnet7 CIDR(default: 199.0.6.0/24):"
read subnetCidr7
if [ -z "$subnetCidr7" ]
then
    subnetCidr7="199.0.6.0/24"
fi

echo "Enter private subnet8 CIDR(default: 199.0.7.0/24):"
read subnetCidr8
if [ -z "$subnetCidr8" ]
then
    subnetCidr8="199.0.7.0/24"
fi

echo "Enter AMI ID:"
read amiId
if [ -z "$amiId" ]
then
    echo "FAIL: AMI ID is empty"
    exit
fi

echo "Enter S3 bucket name (default: prod.weifenglai.me):"
read s3BucketName
if [ -z "$s3BucketName" ]
then
    s3BucketName="prod.weifenglai.me"
fi

echo "Enter domain name (default: prod.weifenglai.me.):"
read domainName
if [ -z "$domainName" ]
then
   domainName="prod.weifenglai.me."
fi

echo "Enter CICD S3 bucket name (default: codedeploy.prod.weifenglai.me):"
read cicdS3BucketName
if [ -z "$cicdS3BucketName" ]
then
    cicdS3BucketName="codedeploy.prod.weifenglai.me"
fi

echo "Enter SSL certificate ARN (default: arn:aws:acm:us-east-1:525744894242:certificate/d15fa624-5b8a-4481-a611-3d77422f078e):"
read sslCertificateArn
if [ -z "$sslCertificateArn" ]
then
    sslCertificateArn="arn:aws:acm:us-east-1:525744894242:certificate/d15fa624-5b8a-4481-a611-3d77422f078e"
fi

status=$(aws cloudformation create-stack --stack-name $stackName --profile $account \
--template-body file://$templatePath \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=VPCNAME,ParameterValue=$vpcName \
ParameterKey=IGWNAME,ParameterValue=$igwName \
ParameterKey=RTNAME,ParameterValue=$rtName \
ParameterKey=VPCCIDR,ParameterValue=$vpcCidr \
ParameterKey=SubnetCIDR1,ParameterValue=$subnetCidr1 \
ParameterKey=SubnetCIDR2,ParameterValue=$subnetCidr2 \
ParameterKey=SubnetCIDR3,ParameterValue=$subnetCidr3 \
ParameterKey=SubnetCIDR4,ParameterValue=$subnetCidr4 \
ParameterKey=SubnetCIDR5,ParameterValue=$subnetCidr5 \
ParameterKey=SubnetCIDR6,ParameterValue=$subnetCidr6 \
ParameterKey=SubnetCIDR7,ParameterValue=$subnetCidr7 \
ParameterKey=SubnetCIDR8,ParameterValue=$subnetCidr8 \
ParameterKey=AMIID,ParameterValue=$amiId \
ParameterKey=S3BucketName,ParameterValue=$s3BucketName \
ParameterKey=DomainName,ParameterValue=$domainName \
ParameterKey=CICDS3BucketName,ParameterValue=$cicdS3BucketName \
ParameterKey=SSLCertificateArn,ParameterValue=$sslCertificateArn \
)
# --on-failure DELETE)

if [ $? -eq 0 ]
then
    echo "please wait....."
    aws cloudformation wait stack-create-complete --stack-name $stackName --profile $account
    if [ $? -eq 0 ]
    then
        echo "Successfully setup the stack"
        echo $status
    else
        echo "Failed: failed to deploy the stack"
        echo $status
    fi
else
    echo "Failed: failed to deploy the stack"
    echo $status
fi

