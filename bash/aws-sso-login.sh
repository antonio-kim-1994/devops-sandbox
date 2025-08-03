#!/bin/bash
IS_CLEAR=false;
case $1 in
  -c) IS_CLEAR=true;
      ;;
esac

if $IS_CLEAR ; then
  echo "remove .sh_cache";
  rm -rf ~/.aws/sh_cache;
fi;

SESSION_NAME='d-9b670cd025';
REGION="ap-northeast-2";

if ! command -v jq
then
    echo 'Install jq';
    brew install jq -y;
fi

echo "${SESSION_NAME}
https://${SESSION_NAME}.awsapps.com/start
${REGION}
sso:account:access" | aws configure sso-session | xargs
aws sso login --sso-session "${SESSION_NAME}" | xargs

if [ -f "$HOME/.aws/sh_cache" ]; then
  echo ".sh_cache exsits";
  SELECT_LIST=$(cat "$HOME/.aws/sh_cache")
else
  echo ".sh_cache does not exsits";

  export latest_sso_file="$(ls -1t "${HOME}/.aws/sso/cache" | head -n 1)"
  export access_token="$(jq -r .accessToken "${HOME}/.aws/sso/cache/${latest_sso_file}")"
  account_list_json="$(aws sso list-accounts --access-token "${access_token}" --region "${REGION}")"
  account_list=$(echo "$account_list_json" | jq -r '.accountList[].accountId')

  for account_id in $account_list
    do
      account_name="$(echo "${account_list_json}" | jq -r ".accountList[] | select(.accountId == \"${account_id}\") | .accountName")"
      role_list_json="$(aws sso list-account-roles --access-token "${access_token}" --account-id "${account_id}" --region $REGION)"
      role_list=$(echo "$role_list_json" | jq -r '.roleList[].roleName');
    for role_name in $role_list
      do
        profile_name="$(echo "${account_name}_${role_name}" | sed 's/ /\\ /g')"

        aws configure set "profile.${profile_name}.sso_session" "${SESSION_NAME}"
        aws configure set "profile.${profile_name}.sso_account_id" "${account_id}"
        aws configure set "profile.${profile_name}.sso_role_name" "${role_name}"
        aws configure set "profile.${profile_name}.region" "${REGION}"
        echo "Added ${profile_name}"
        SELECT_LIST+=" ${profile_name}"
    done;
  done;

  echo ${SELECT_LIST} > "${HOME}/.aws/sh_cache";
fi;


PS3='Please enter your Service: ';
select opt in $SELECT_LIST
do
  if [[ -n "$opt" ]]
    then
      SELECTED_SERVICE=$opt;
      break;
  fi;
  echo "!@#";
  echo $opt;
  echo "Invalid Selection";
done
CREDENTAIL_STRING=$(aws configure export-credentials --profile $SELECTED_SERVICE --format env-no-export);

cat <<EOF > $HOME/.aws/credentials
[default]
$CREDENTAIL_STRING
EOF

echo "DONE";