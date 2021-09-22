set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

set_up_aws_user_credentials() {
    unset AWS_SESSION_TOKEN
    export AWS_DEFAULT_REGION=$1
    export AWS_ACCESS_KEY_ID=$2
    export AWS_SECRET_ACCESS_KEY=$3
}

assume_role() {
    AWS_ACCOUNT_ID=$1
    ROLE_NAME=$2

    ROLE_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME"
    CREDENTIALS_FILE_NAME="aws-credentials.json"
    aws sts assume-role --role-arn $ROLE_ARN --role-session-name github-session >> $CREDENTIALS_FILE_NAME

    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' $CREDENTIALS_FILE_NAME)
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' $CREDENTIALS_FILE_NAME)
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' $CREDENTIALS_FILE_NAME)
}

log_action "deploying cloudformation stack"
REGION=$1
log_key_value_pair "region" $REGION
ACCESS_KEY=$2
log_key_value_pair "access-key" $ACCESS_KEY
SECRET_KEY=$3
ACCOUNT_ID=$4
log_key_value_pair "account-id" $ACCOUNT_ID
ROLE_NAME=$5
log_key_value_pair "role-name" $ROLE_NAME
STACK_NAME=$6
log_key_value_pair "stack-name" $STACK_NAME
TEMPLATE_BODY_PATH=$7
log_key_value_pair "template-body-path" $TEMPLATE_BODY_PATH
TEMPLATE_BODY="$WORKING_FOLDER/$TEMPLATE_BODY_PATH"
# cat $TEMPLATE_BODY
CFN_PARAMETERS_PATH=$8
log_key_value_pair "cfn-parameters-path" $CFN_PARAMETERS_PATH
CFN_PARAMETERS_FILE="$WORKING_FOLDER/$CFN_PARAMETERS_PATH"
# cat $CFN_PARAMETERS_FILE

set_up_aws_user_credentials $REGION $ACCESS_KEY $SECRET_KEY
assume_role $ACCOUNT_ID $ROLE_NAME

STACK=$(aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r '.Stacks[0]')
STACK_FILE="stack-file.json"
if [ -z "$STACK" ]; 
then
    log_action "creating stack"
    aws cloudformation create-stack \
        --stack-name $STACK_NAME \
        --template-body "file://$TEMPLATE_BODY" \
        --parameters "file://$CFN_PARAMETERS_FILE" \
        --capabilities "CAPABILITY_NAMED_IAM" >> $STACK_FILE
    STACK_ARN=$(jq -r '.StackId' $STACK_FILE)
    log_key_value_pair "stack-arn" $STACK_ARN
    aws cloudformation wait stack-create-complete \
        --stack-name $STACK_ARN
else
    log_action "updating stack"
    aws cloudformation update-stack \
        --stack-name $STACK_NAME \
        --template-body "file://$TEMPLATE_BODY" \
        --parameters "file://$CFN_PARAMETERS_FILE" \
        --capabilities "CAPABILITY_NAMED_IAM" >> $STACK_FILE
    STACK_ARN=$(jq -r '.StackId' $STACK_FILE)
    log_key_value_pair "stack-arn" $STACK_ARN
    aws cloudformation wait stack-update-complete \
        --stack-name $STACK_ARN
fi