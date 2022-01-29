#!/bin/bash

set -e

export NEXTAUTH_URL="${BASE_URL}/api/auth"
export NEXT_PUBLIC_APP_URL=$BASE_URL

# EXPOSE_PRISMA_STUDIO=$(jq --raw-output ".expose_prisma_studio" $CONFIG_PATH)

# The `NEXT_PUBLIC_APP_URL` variable needs to be set at build time. We use this technique to set it at runtime
# https://github.com/vercel/next.js/discussions/17641#discussioncomment-339555
function apply_app_url() {
    echo "Check that we have NEXT_PUBLIC_APP_URL vars"
    test -n "NEXT_PUBLIC_APP_URL"
    find .next \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i "s#APP_NEXT_PUBLIC_APP_URL_VAR#$NEXT_PUBLIC_APP_URL#g"
}
apply_app_url

yarn run db-migrate

yarn start