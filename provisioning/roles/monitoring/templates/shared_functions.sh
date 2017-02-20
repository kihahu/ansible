#!/bin/bash
slack_webhook={{ monit_slack_webhook }}
slack_alert()
{
	payload='{"channel": "'$slack_channel'", "username": "'$title'", "color": "danger", "attachments": [{"fallback": "'$1'", "color": "danger", "mrkdwn_in": ["fields"], "fields": [{"title": "", "value": "'$message'"}], "footer": "", "ts": "'$timestamp'"}]}'
	curl -X POST -H 'Content-Type: application/json' -d "$payload" $slack_webhook
}
