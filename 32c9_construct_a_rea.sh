#!/bin/bash

# Web App Notifier

# Configuration
NOTIFIER_INTERVAL=5 # seconds
NOTIFIER_URL="https://example.com/api/notifications"

# Function to get new notifications
get_notifications() {
  curl -s -X GET "$NOTIFIER_URL" | jq '.notifications[] | .title + ": " + .message'
}

# Function to send desktop notification
send_notification() {
  local title=$1
  local message=$2
  echo "Sending notification: $title - $message"
  # Replace with your desktop notification command
  # For example, on Linux with libnotify:
  # notify-send "$title" "$message"
}

# Main loop
while true
do
  # Get new notifications
  NEW_NOTIFICATIONS=$(get_notifications)

  # Check if there are new notifications
  if [ -n "$NEW_NOTIFICATIONS" ]; then
    # Send desktop notification for each new notification
    for notification in $NEW_NOTIFICATIONS; do
      title=$(echo "$notification" | cut -d: -f1)
      message=$(echo "$notification" | cut -d: -f2-)
      send_notification "$title" "$message"
    done
  fi

  # Wait for the next interval
  sleep $NOTIFIER_INTERVAL
done