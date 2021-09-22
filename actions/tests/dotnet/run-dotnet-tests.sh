set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "testing"
SLN_FOLDER=$1
log_key_value_pair "sln-folder" $SLN_FOLDER

REGEX="$WORKING_FOLDER/$SLN_FOLDER/*.sln"
log_key_value_pair "regex" $REGEX
for i in $REGEX; do 
    log_action "testing solution (.sln)"
    log_key_value_pair "solution" $i
    dotnet test $i -c Release
done

cd $WORKING_FOLDER