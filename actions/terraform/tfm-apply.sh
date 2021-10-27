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

log_action "planning terraform"
REGION=$1
log_key_value_pair "region" $REGION
ACCESS_KEY=$2
log_key_value_pair "access-key" $ACCESS_KEY
SECRET_KEY=$3
ACCOUNT_ID=$4
log_key_value_pair "account-id" $ACCOUNT_ID
ROLE_NAME=$5
log_key_value_pair "role-name" $ROLE_NAME
TFM_FOLDER=$6
log_key_value_pair "terraform-folder" $TFM_FOLDER
BACKEND_CONFIG_FILE=$7
log_key_value_pair "backend-config-file" $BACKEND_CONFIG_FILE
TERRAFORM_PLAN_FILE=$8
log_key_value_pair "terraform-plan-file" $TERRAFORM_PLAN_FILE

set_up_aws_user_credentials $REGION $ACCESS_KEY $SECRET_KEY
assume_role $ACCOUNT_ID $ROLE_NAME

FOLDER="$WORKING_FOLDER/$TFM_FOLDER"
cd $FOLDER

terraform init -backend-config="$BACKEND_CONFIG_FILE"
PLAN="$WORKING_FOLDER/$TERRAFORM_PLAN_FILE"
terraform apply "$PLAN"

cd "$WKDIR"