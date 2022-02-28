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

echo "Enter subnet1 CIDR(default: 199.0.0.0/24):"
read subnetCidr1
if [ -z "$subnetCidr1" ]
then
    subnetCidr1="199.0.0.0/24"
fi

echo "Enter subnet2 CIDR(default: 199.0.1.0/24):"
read subnetCidr2
if [ -z "$subnetCidr2" ]
then
    subnetCidr2="199.0.1.0/24"
fi

echo "Enter subnet3 CIDR(default: 199.0.2.0/24):"
read subnetCidr3
if [ -z "$subnetCidr3" ]
then
    subnetCidr3="199.0.2.0/24"
fi

echo "Enter AMI ID:"
read amiId
if [ -z "$amiId" ]
then
    echo "FAIL: AMI ID is empty"
    exit
fi

status=$(aws cloudformation create-stack --stack-name $stackName --profile $account \
--template-body file://$templatePath \
--parameters ParameterKey=VPCNAME,ParameterValue=$vpcName \
ParameterKey=IGWNAME,ParameterValue=$igwName \
ParameterKey=RTNAME,ParameterValue=$rtName \
ParameterKey=VPCCIDR,ParameterValue=$vpcCidr \
ParameterKey=SubnetCIDR1,ParameterValue=$subnetCidr1 \
ParameterKey=SubnetCIDR2,ParameterValue=$subnetCidr2 \
ParameterKey=SubnetCIDR3,ParameterValue=$subnetCidr3 \
ParameterKey=AMIID,ParameterValue=$amiId \
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

