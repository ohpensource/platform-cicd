set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "creating iac artifacts"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "service-name" $SERVICE_NAME
IAC=$3
log_key_value_pair "iac" $IAC
BUCKET_NAME=$4
log_key_value_pair "bucket-name" $BUCKET_NAME

DESTINATION_IAC="./$SERVICE_NAME-$VERSION-$IAC.zip"
log_key_value_pair "destination-iac" $DESTINATION_IAC
zip -r $DESTINATION_IAC "./$IAC"
S3_DESTINATION="s3://$BUCKET_NAME/$SERVICE_NAME/$VERSION/$SERVICE_NAME-$VERSION-$IAC.zip"
log_key_value_pair "s3-destination" $S3_DESTINATION
aws s3 cp $DESTINATION_IAC $S3_DESTINATION

cd $WORKING_FOLDER