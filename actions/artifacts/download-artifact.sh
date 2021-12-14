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

log_action "downloading artifact"
REGION=$1
log_key_value_pair "region" $REGION
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
IAC=$8
log_key_value_pair "iac" $IAC
BUCKET_NAME=$9
log_key_value_pair "bucket-name" $BUCKET_NAME
DESTINATION_FOLDER=${10}
DESTINATION_FOLDER="$WORKING_FOLDER/$DESTINATION_FOLDER"
log_key_value_pair "destination-folder" $DESTINATION_FOLDER

set_up_aws_user_credentials $REGION $ACCESS_KEY $SECRET_KEY
assume_role $ACCOUNT_ID $ROLE_NAME

S3_ORIGIN="s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION"
log_key_value_pair "s3-origin" $S3_ORIGIN
mkdir -p $DESTINATION_FOLDER
aws s3 cp --recursive $S3_ORIGIN $DESTINATION_FOLDER

REGEX="$DESTINATION_FOLDER/*-$IAC.zip"
log_key_value_pair "iac-regex" $REGEX
for i in $REGEX; do 
    log_action "unzipping iac artifact"
    log_key_value_pair "file" $i
    unzip $i -d $DESTINATION_FOLDER
done

tree $DESTINATION_FOLDER
cd $WORKING_FOLDER