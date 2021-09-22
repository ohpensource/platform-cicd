set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "validating terraform"
TFM_PATH=$1
log_key_value_pair "tfm-path" $TFM_PATH

cd $WORKING_FOLDER/$TFM_PATH

terraform init
terraform validate

cd $WORKING_FOLDER