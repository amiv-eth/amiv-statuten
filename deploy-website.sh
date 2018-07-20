#!/usr/bin/env bash
HOST="https://gitlab.ethz.ch/api/v4/projects/"
SOURCE_BRANCH="statutes-${CI_COMMIT_SHA}"

git clone --recursive "https://${USERNAME}:${PRIVATE_TOKEN}@$WEBSITE_REPO_GIT_HTTP_URL_WITHOUT_PROTOCOL" website
cd website
git config user.email $GITLAB_USER_EMAIL
git config user.name $GITLAB_USER_NAME
git checkout -b $SOURCE_BRANCH
cd amiv-statuten
git checkout $CI_COMMIT_SHA
cd ../
git commit -am "Update statutes"
git push -f --set-upstream origin $SOURCE_BRANCH

# The description of our new MR, we want to remove the branch after the MR has
# been closed
BODY="{
    \"id\": ${WEBSITE_PROJECT_ID},
    \"source_branch\": \"${SOURCE_BRANCH}\",
    \"target_branch\": \"master\",
    \"remove_source_branch\": true,
    \"title\": \"Update Statutes to ${CI_COMMIT_SHA}\",
    \"assignee_id\":\"${GITLAB_USER_ID}\"
}";

# Require a list of all the merge request and take a look if there is already
# one with the same source branch
LISTMR=`curl --silent "${HOST}${WEBSITE_PROJECT_ID}/merge_requests?state=opened" --header "PRIVATE-TOKEN:${PRIVATE_TOKEN}"`;
COUNTBRANCHES=`echo ${LISTMR} | grep -o "\"source_branch\":\"${SOURCE_BRANCH}\"" | wc -l`;

# No MR found, let's create a new one
if [ ${COUNTBRANCHES} -eq "0" ]; then
    curl -X POST "${HOST}${WEBSITE_PROJECT_ID}/merge_requests" \
        --header "PRIVATE-TOKEN:${PRIVATE_TOKEN}" \
        --header "Content-Type: application/json" \
        --data "${BODY}";

    echo "Opened a new merge request: \"Update Statutes to ${CI_COMMIT_SHA}\" and assigned to you";
    exit;
fi

echo "No new merge request opened";
