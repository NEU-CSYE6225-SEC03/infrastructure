echo "Use dev or demo AWS account?"
echo "Enter(dev / demo):"
read account
if [ "$account" != "dev" ] && [ "$account" != "demo" ]
then
    echo "Failed: enter a account"
    exit
fi

echo "Enter path of cloudformation file path(default: cicd.json):"
read templatePath
if [ -z "$templatePath" ]; then
    templatePath="cicd.json"
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
echo "Enter S3 bucket name (default: codedeploy.prod.weifenglai.me):"
read s3BucketName
if [ -z "$s3BucketName" ]
then
    s3BucketName="codedeploy.prod.weifenglai.me"
fi

status=$(aws cloudformation create-stack --stack-name $stackName --profile $account \
--template-body file://$templatePath \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=S3BucketName,ParameterValue=$s3BucketName \
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

