#!/bin/bash

# Usage:
# sudo bash abandobe.bash

echo "You may be asked for password to process the cleanup. It's safe and trust me..."

# Remove agents/daemons
declare -a adobeDaemonAgentDir=(
  "$HOME/Library/LaunchAgents"
  '/Library/LaunchAgents'
  '/Library/LaunchDaemons'
  '/Library/PrivilegedHelperTools'
)

for daemonAgentDir in "${adobeDaemonAgentDir[@]}"; do
  find "$daemonAgentDir" -name 'com.adobe*' -delete -print
done

# Kill script inspired by:
# https://gist.github.com/dominicstop/6809bda4e1da08871262650f1fdfbcc6
declare -a adobeProcessList=(
  'AdobeCRDaemon'
  'AdobeIPCBroker'
  'com.adobe.acc.installer.v2'
  'CCXProcess.app'
  'CCLibrary.app'
  'Adobe CEF Helper'
  'Core Sync'
  'Creative Cloud Helper'
  'Adobe Desktop Service'
  'Creative Cloud'
)

# Remove predefined processes
for processName in "${adobeProcessList[@]}"; do
  if ! pgrep -f "$processName" >/dev/null; then
    echo "process not running, skipping: ${processName}"
    continue
  fi

  results=$(pgrep -fl "$processName")
  echo "$results" | awk -v pid='' '{pid=$1; $1=""; print "\nkill process:" $0 " (" pid ")\n"}'
  pid="$(awk '{print $1}' <<<"$results")"
  kill -9 "$pid"

  if pgrep -f "$processName" >/dev/null; then
    killall -9 "$processName"
  fi
done

# Remove processes start with Adobe
for processID in $(pgrep -f 'Adobe|adobe'); do
  processName=$(ps -p "$processID" -o command | awk 'FNR == 2 {print}')
  if [ -z "$processName" ]; then
    continue
  fi

  printf "kill process: %s\n" "$processName"
  kill -9 "$processID"
done
