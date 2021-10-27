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

log_action "planning terraform"
REGION=$1
log_key_value_pair "region" $REGION
ACCESS_KEY=$2
log_key_value_pair "access-key" $ACCESS_KEY
SECRET_KEY=$3
TFM_FOLDER=$4
log_key_value_pair "terraform-folder" $TFM_FOLDER
BACKEND_CONFIG_FILE=$5
log_key_value_pair "backend-config-file" $BACKEND_CONFIG_FILE
TFVARS_FILE=$6
log_key_value_pair "tfvars-file" $TFVARS_FILE
TFSTATE_OUTPUT=$7
log_key_value_pair "tfstate-output" $TFSTATE_OUTPUT

set_up_aws_user_credentials $REGION $ACCESS_KEY $SECRET_KEY

BACKEND_CONFIG_FILE="$WORKING_FOLDER/$BACKEND_CONFIG_FILE"
TFVARS_FILE="$WORKING_FOLDER/$TFVARS_FILE"
TFSTATE_OUTPUT="$WORKING_FOLDER/$TFSTATE_OUTPUT"
mkdir -p $(dirname $TFSTATE_OUTPUT)

FOLDER="$WORKING_FOLDER/$TFM_FOLDER"
cd $FOLDER

terraform init -backend-config="$BACKEND_CONFIG_FILE"
terraform plan -var-file="$TFVARS_FILE" -out="$TFSTATE_OUTPUT"

cd "$WKDIR"