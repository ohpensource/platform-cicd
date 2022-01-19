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
    local CREDENTIALS_FILE_NAME="aws-credentials-$(basename "$0").json"
    if [[ ! -f "$CREDENTIALS_FILE_NAME" ]]; then
        local AWS_ACCOUNT_ID=$1
        local ROLE_NAME=$2
        localROLE_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME"
        aws sts assume-role --role-arn $ROLE_ARN --role-session-name github-session > $CREDENTIALS_FILE_NAME
    fi

    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' $CREDENTIALS_FILE_NAME)
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' $CREDENTIALS_FILE_NAME)
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' $CREDENTIALS_FILE_NAME)
}

log_action "uploading lambda artifact to s3"
REGION=$1
log_key_value_pair "aws-region" $REGION
ACCESS_KEY=$2
log_key_value_pair "access-key" $ACCESS_KEY
SECRET_KEY=$3
ACCOUNT_ID=$4
log_key_value_pair "account-id" $ACCOUNT_ID
ROLE_NAME=$5
log_key_value_pair "role-name" $ROLE_NAME
VERSION=$(echo "$6"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$7
log_key_value_pair "service-name" $SERVICE_NAME
FUNCTION_PROJECT_NAME=$8
log_key_value_pair "function-project-name" $FUNCTION_PROJECT_NAME
ARTIFACT_FOLDER=$9
log_key_value_pair "artifact-path" $ARTIFACT_FOLDER
BUCKET_NAME=${10}
log_key_value_pair "bucket-name" $BUCKET_NAME

set_up_aws_user_credentials $REGION $ACCESS_KEY $SECRET_KEY
assume_role $ACCOUNT_ID $ROLE_NAME

ARTIFACT_PATH="$WORKING_FOLDER/$ARTIFACT_FOLDER/$SERVICE_NAME-$VERSION-$FUNCTION_PROJECT_NAME.zip"
S3_DESTINATION="s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION/$SERVICE_NAME-$VERSION-$FUNCTION_PROJECT_NAME.zip"
log_key_value_pair "s3-destination" $S3_DESTINATION
aws s3 cp $ARTIFACT_PATH $S3_DESTINATION

echo "::set-output name=s3_destination_key::${S3_DESTINATION}"
