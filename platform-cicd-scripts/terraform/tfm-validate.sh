set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/platform-cicd-scripts/_common/logging.sh

log_action "validating terraform"
TFM_PATH=$1
log_key_value_pair "tfm-path" $TFM_PATH

cd $WORKING_FOLDER/$TFM_PATH

terraform init
terraform validate

cd $WORKING_FOLDER