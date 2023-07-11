## Setup OIDC
Upon cluster installation (e.g. on AWS with `pural bundle install sentry aws-sentry`) you can opt to use Plural OIDC as the SSO provider.
This will prepare a new OIDC client in the Plural OIDC service, but not yet configure and authorize Sentry to use it.
The only way to do that is through the UI performing the followings steps:

1. Login to the Sentry UI as an admin user.
2. Go to the `Settings` section of the Sentry UI.
3. Under `Organization` select the `Auth` tab.
4. In the provider list you should see an option for Plural's OIDC client at `https://oidc.plural.sh`.
5. Click the `Configure` button next to it.
6. You will be redirected to the Plural OIDC service to authorize Sentry to access your Plural profile. 
   Click `Allow`.
7. You will be redirected back to a Sentry configuration page at `sentry.dev.plural.sh/organizations/sentry/auth/configure/`.
   At the top there should be a green banner saying `You have successfully linked your account to your SSO provider`.
8. Leave the displayed settings as is and click `Save Settings`.
9. Go back to the main page of Sentry and click `Logout` on your profile the top left corner.
10. You will be redirected to the Sentry login page that should now have a `Login with https://oidc.plural.sh` button.