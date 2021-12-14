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
    CREDENTIALS_FILE_NAME="aws-credentials.json"
	if [[ ! -f "$CREDENTIALS_FILE_NAME" ]]; then
		AWS_ACCOUNT_ID=$1
        ROLE_NAME=$2
		ROLE_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME"
    	aws sts assume-role --role-arn $ROLE_ARN --role-session-name github-session > $CREDENTIALS_FILE_NAME
	fi

    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' $CREDENTIALS_FILE_NAME)
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' $CREDENTIALS_FILE_NAME)
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' $CREDENTIALS_FILE_NAME)
}

log_action "validating cloudformation"
CFN_TEMPLATE=$1
log_key_value_pair "cfn-template" $CFN_TEMPLATE
REGION=$2
log_key_value_pair "aws-region" $REGION
ACCESS_KEY=$3
log_key_value_pair "access-key" $ACCESS_KEY
SECRET_KEY=$4
ACCOUNT_ID=$5
log_key_value_pair "account-id" $ACCOUNT_ID
ROLE_NAME=$6
log_key_value_pair "role-name" $ROLE_NAME

set_up_aws_user_credentials $REGION $ACCESS_KEY $SECRET_KEY
assume_role $ACCOUNT_ID $ROLE_NAME
aws cloudformation validate-template --template-body "file://$WORKING_FOLDER/$CFN_TEMPLATE" --region $REGION

cd $WORKING_FOLDER