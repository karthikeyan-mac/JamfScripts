#!/bin/bash

# Karthikeyan Marappan
# Slack Notification from Jamf Pro Policy using Slack Webhooks.
# Exit immediately on error

set -e

# --- Input Parameters ---
#https://api.slack.com/messaging/webhooks
SLACK_WEBHOOK_URL="<SLACKWEBHOOKURL>"

# Confiure Script parameters in Jamf Policy to match with variable.
SLACK_TITLE_TEXT="$4"
SLACK_AUTHOR_NAME="$5"
SLACK_COLOR="$6"
SLACK_ATTACHMENT_TEXT="${7}"

# --- Optional Pretext (can be modified if needed) ---
SLACK_PRETEXT_TEXT=""

# --- Author Icon URL (Optional) ---

SLACK_AUTHOR_ICON_URL=""
# --- Replace author name with Serial Number if instructed ---
if [[ "$SLACK_AUTHOR_NAME" == *"SERIALNUMBER"* ]]; then
    SLACK_AUTHOR_NAME="$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F'"' '/IOPlatformSerialNumber/ { print $4; exit }')"
fi

# Refer Attachment options in Slack Docs
# ----https://api.slack.com/reference/messaging/attachments-----


# --- Send Slack Notification ---
payload=$(cat <<EOF
{
  "text": "$SLACK_TITLE_TEXT",
  "attachments": [
    {
      "fallback": "Notification from Jamf",
      "color": "$SLACK_COLOR",
      "pretext": "$SLACK_PRETEXT_TEXT",
      "author_name": "$SLACK_AUTHOR_NAME",
      "author_icon": "$SLACK_AUTHOR_ICON_URL",
      "text": "$SLACK_ATTACHMENT_TEXT"
    }
  ]
}
EOF
)

curl -s -X POST -H 'Content-type: application/json' --data "$payload" "$SLACK_WEBHOOK_URL"