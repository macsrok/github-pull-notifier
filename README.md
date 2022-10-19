run with mounted volume to /config. The config file should be YAML formatted. The following options are available:

GITHUB_TOKEN: GitHub API token. Required.
ALLOWED_GITHUB_USERS:
  - github_user1
  - github_user2
  - github_user3
  - users not in this list will be ingnored
SLACK_TOKEN: Slack API token. Required.
GITHUB_TO_SLACK_MAP:
  github_user1: SLACK_ID
  github_user2: SLACK_ID
  github_user3: SLACK_ID
  github_username: SLACK_ID, without this mapping users will not recieve notifications
OWNER: GitHub repo owner. Required.
REPO: GitHub repo name. Required.

Adjust entrypoint.sh to your needs. The default is to run the script @ 9:45AM Mon-Friday.

docker build .
docker run -d --restart=unless-stopped -v /folder/containing/config.yaml:/config IMAGE_ID