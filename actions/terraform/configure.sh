set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "configuring terraforn environment"
BACKEND_CONF_FILE=$1
log_key_value_pair "backend-configuration-file" $BACKEND_CONF_FILE
TFM_VARS_FILE=$2
log_key_value_pair "terraform-variables-file" $TFM_VARS_FILE
DESTINATION_FOLDER=$3
log_key_value_pair "destination-folder" $DESTINATION_FOLDER
BACKEND_VARS_TO_OVERRIDE=$4
log_key_value_pair "backend-variables-to-override" $BACKEND_VARS_TO_OVERRIDE
TFM_VARS_TO_OVERRIDE=$5
log_key_value_pair "terraform-variables-to-override" $TFM_VARS_TO_OVERRIDE

# DESTINATION_FOLDER="$WORKING_FOLDER/$DESTINATION_FOLDER"
# mkdir -p $DESTINATION_FOLDER
# CLIENT_NAME=team
# STAGE="dev"
# SERVICE_GROUP=$(echo "$GITHUB_HEAD_REF"|tr '/' '-')
# BACKEND_CONF="configuration/team/branch/team-branch.backend.tfvars"
# sed -i "s#<client-name>#$CLIENT_NAME#g" $BACKEND_CONF
# sed -i "s#<stage-name>#$STAGE#g" $BACKEND_CONF
# sed -i "s#<service-group>#$SERVICE_GROUP#g" $BACKEND_CONF
# sed -i "s#<service-name>#$SERVICE_NAME#g" $BACKEND_CONF
# cp $BACKEND_CONF "deployment-conf/backend.tfvars"

# TFM_VARS="configuration/team/branch/team-branch.tfvars.json"
# SERVICE_VERSION=$(echo "$GITHUB_HEAD_REF"|tr '/' '-')
# LAMBDA_ARTIFACT_KEY="$SERVICE_NAME/$SERVICE_VERSION/$SERVICE_NAME-$SERVICE_VERSION-$FUNCTION_NAME.zip"
# sed -i "s#<service-version>#$SERVICE_VERSION#g" $TFM_VARS
# sed -i "s#<service-group>#$SERVICE_GROUP#g" $TFM_VARS
# sed -i "s#<lambda-artifact-key>#$LAMBDA_ARTIFACT_KEY#g" $TFM_VARS
# sed -i "s#<service-name>#$SERVICE_NAME#g" $TFM_VARS
# cp $TFM_VARS "deployment-conf/terraform.tfvars.json"

cd "$WKDIR"