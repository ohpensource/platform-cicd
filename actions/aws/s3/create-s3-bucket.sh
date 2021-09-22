set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "creating s3 bucket"
S3_BUCKET_NAME=$1
log_key_value_pair "s3-bucket" $S3_BUCKET_NAME
REGION=$2
log_key_value_pair "aws-region" $REGION
aws s3api create-bucket \
    --bucket $S3_BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION \
    || true

cd $WORKING_FOLDER