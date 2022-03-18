#!/bin/bash

# Usage:
# sudo bash abandobe.bash

echo "You may be asked for password to process the cleanup. It's safe and trust me...";

# Remove agents/daemons
declare -a adobeDaemonAgentDir=(
  "$HOME/Library/LaunchAgents"
  '/Library/LaunchAgents'
  '/Library/LaunchDaemons'
);

for daemonAgentDir in "${adobeDaemonAgentDir[@]}"; do
  find "$daemonAgentDir" -name 'com.adobe*' -delete -print;
done;

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
);

# Remove predefined processes
for processName in "${adobeProcessList[@]}"; do
  pgrep -f "$(echo $processName)" > /dev/null;

  if [ $? -ne 0 ]; then
    echo "process not running, skipping: ${processName}";
    continue;
  fi;

  results=$(pgrep -fl "$(echo $processName)");
  echo $results | awk -v pid='' '{pid=$1; $1=""; print "\nkill process:" $0 " (" pid ")\n"}';
  kill -9 $(echo $results | awk '{print $1}');

  if pgrep -f "$(echo $processName)" > /dev/null; then
    killall -9 "$(echo processName)";
  fi;
done;

# Remove processes start with Adobe
for processID in $(pgrep -f 'Adobe|adobe'); do
  processName=$(ps -p $processID -o command | awk 'FNR == 2 {print}');
  if [ -z "$processName" ]; then
    continue;
  fi;

  echo "kill process:" $processName "\n";
  kill -9 $processID;
done;
