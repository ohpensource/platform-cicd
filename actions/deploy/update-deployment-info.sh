set -e

CUSTOMER=$1
ENVIRONMENT=$2
SERVICE_GROUP=$3
SOFTWARE_VERSION=$4

DEPLOY_INFO_FILE=${{ github.workspace }}/configuration/$CUSTOMER/$ENVIRONMENT/deploy-$SERVICE_GROUP.info
echo "Deployment info file path: $DEPLOY_INFO_FILE"

TIME_STAMP="$(date +%R-%d-%m-%Y)"

if [[ -f "$DEPLOY_INFO_FILE" ]]; then
    rm $DEPLOY_INFO_FILE
fi

echo "version=$SOFTWARE_VERSION" > $DEPLOY_INFO_FILE
echo "time=$TIME_STAMP UTC" >> $DEPLOY_INFO_FILE

git config user.email "github-svc@ohpen.com"
git config user.name "${{ github.actor }}"

if [ -n "$(git status --porcelain)" ]; then
  git add "$DEPLOY_INFO_FILE"
  git commit -m "[skip ci] Application deployed to '$ENVIRONMENT' for customer '$CUSTOMER' and service group '$SERVICE_GROUP' with version: '$SOFTWARE_VERSION'"
  git push;
else
  echo "no change detected";
fi