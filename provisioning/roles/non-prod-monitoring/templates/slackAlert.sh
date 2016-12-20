#!/bin/bash
. {{ monitor_scripts_dir }}shared_functions.sh

slack_channel="{{ monit_slack_channel }}"
message="$MONIT_DATE: $MONIT_HOST - $MONIT_EVENT"

slack_alert
