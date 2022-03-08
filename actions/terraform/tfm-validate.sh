set -e 
working_folder=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "validating terraform"

while getopts t:b: flag
do
    case "${flag}" in
       t) tfm_path=${OPTARG};;
       b) backend=${OPTARG};;
    esac
done

log_key_value_pair "tfm-path" $tfm_path
log_key_value_pair "use-backend" $backend

cd "$working_folder/$tfm_path"
    terraform init -backend=$backend
    terraform validate -no-color
cd "$working_folder"