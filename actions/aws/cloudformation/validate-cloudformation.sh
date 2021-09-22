set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "validating cloudformation"
CFN_TEMPLATE=$1
log_key_value_pair "cfn-template" $CFN_TEMPLATE
REGION=$2
log_key_value_pair "aws-region" $REGION
aws cloudformation validate-template --template-body "file://$WORKING_FOLDER/$CFN_TEMPLATE" --region $REGION

cd $WORKING_FOLDER