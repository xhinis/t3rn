channel_logo() {
  echo -e '\033[0;31m'
  echo -e 'Darksun Nodes '
  echo -e '\e[0m'"
}

update_node() {
  delete_node

  if [ -d "$HOME/executor" ] || screen -list | grep -q "\.t3rnnode"; then
    echo 'The executor folder or the t3rnnode session already exists. Installation is not possible. Choose to delete the node or exit the script.'
    return
  fi

  echo 'Starting node update...'

  read -p "Enter your private key: " PRIVATE_KEY_LOCAL

  cd $HOME

  sudo wget https://github.com/t3rn/executor-release/releases/download/v0.32.0/executor-linux-v0.32.0.tar.gz -O executor-linux.tar.gz
  sudo tar -xzvf executor-linux.tar.gz
  sudo rm -rf executor-linux.tar.gz
  cd executor

  export NODE_ENV="testnet"
  export LOG_LEVEL="debug"
  export LOG_PRETTY="false"
  export EXECUTOR_PROCESS_ORDERS="true"
  export EXECUTOR_PROCESS_CLAIMS="true"
  export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
  export ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn"
  export RPC_ENDPOINTS_BSSP="https://base-sepolia-rpc.publicnode.com"
  export RPC_ENDPOINTS_L1RN='https://brn.rpc.caldera.xyz/'
  export EXECUTOR_MAX_L3_GAS_PRICE=105
  export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API="false"

  cd $HOME/executor/executor/bin/

  screen -dmS t3rnnode bash -c '
    echo "Starting script execution in the screen session"

    cd $HOME/executor/executor/bin/
    ./executor

    exec bash
  '

  echo "Screen session 't3rnnode' created and node started..."
}

download_node() {
  if [ -d "$HOME/executor" ] || screen -list | grep -q "\.t3rnnode"; then
    echo 'The executor folder or the t3rnnode session already exists. Installation is not possible. Choose to delete the node or exit the script.'
    return
  fi

  echo 'Starting node installation...'

  read -p "Enter your private key: " PRIVATE_KEY_LOCAL

  sudo apt update -y && sudo apt upgrade -y
  sudo apt-get install make screen build-essential software-properties-common curl git nano jq -y

  cd $HOME

  sudo wget https://github.com/t3rn/executor-release/releases/download/v0.29.0/executor-linux-v0.29.0.tar.gz -O executor-linux.tar.gz
  sudo tar -xzvf executor-linux.tar.gz
  sudo rm -rf executor-linux.tar.gz
  cd executor

  export NODE_ENV="testnet"
  export LOG_LEVEL="debug"
  export LOG_PRETTY="false"
  export EXECUTOR_PROCESS_ORDERS="true"
  export EXECUTOR_PROCESS_CLAIMS="true"
  export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"
  export ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn"
  export RPC_ENDPOINTS_BSSP="https://base-sepolia-rpc.publicnode.com"
  export RPC_ENDPOINTS_L1RN='https://brn.rpc.caldera.xyz/'
  export EXECUTOR_MAX_L3_GAS_PRICE=105
  export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API="false"

  cd $HOME/executor/executor/bin/

  screen -dmS t3rnnode bash -c '
    echo "Starting script execution in the screen session"

    cd $HOME/executor/executor/bin/
    ./executor

    exec bash
  '

  echo "Screen session 't3rnnode' created and node started..."
}

check_logs() {
  if screen -list | grep -q "\.t3rnnode"; then
    screen -S t3rnnode -X hardcopy /tmp/screen_log.txt && sleep 0.1 && tail -n 100 /tmp/screen_log.txt && rm /tmp/screen_log.txt
  else
    echo "t3rnnode session not found."
  fi
}

change_fee() {
  echo 'Starting fee change...'

  if [ ! -d "$HOME/executor" ]; then
    echo 'The executor folder was not found. Install the node.'
    return
  fi

  read -p 'To which gas GWEI do you want to change? (default 105) ' GWEI_SET

  cd $HOME/executor
  export EXECUTOR_MAX_L3_GAS_PRICE=<span class="math-inline">GWEI\_SET
echo 'Restarting node\.\.\.'
restart\_node
echo 'The fee has been changed\.'
\}
stop\_node\(\) \{
echo 'Starting stop\.\.\.'
if screen \-list \| grep \-q "\\\.t3rnnode"; then
screen \-S t3rnnode \-p 0 \-X stuff "^C"
echo "The node has been stopped\."
else
echo "t3rnnode session not found\."
fi
\}
auto\_restart\_node\(\) \{
screen \-dmS t3rnnode\_auto bash \-c '
echo "Starting script execution in the screen session"
while true; do
restart\_node
sleep 7200
done
exec bash
'
echo "Screen session 't3rnnode\_auto' created and the node will be restarted every 2 hours\.\.\."
\}
restart\_node\(\) \{
echo 'Starting restart\.\.\.'
session\="t3rnnode"
if screen \-list \| grep \-q "\\\.</span>{session}"; then
    screen -S "<span class="math-inline">\{session\}" \-p 0 \-X stuff "^C"
sleep 1
screen \-S "</span>{session}" -p 0 -X stuff "./executor\n"
    echo "The node has been restarted."
  else
    echo "Session ${session} not found."
  fi
}

delete_node() {
  echo 'Starting node deletion...'

  if [ -d "$HOME/executor" ]; then
    sudo rm -rf $HOME/executor
    echo "The executor folder has been deleted."
  else
    echo "The executor folder was not found."
  fi

  if screen -list | grep -q "\.t3rnnode"; then
    sudo screen -X -S t3rnnode quit
    echo "The t3rnnode session has been closed."
  else
    echo "t3rnnode session not found."
  fi

  sudo screen -X -S t3rnnode_auto quit

  echo "The node has been deleted."
}

exit_from_script() {
  exit 0
}

while true; do
  channel_logo
  sleep 2
  echo -e "\n\nMenu:"
  echo "1. 🚀 Install node"
  echo "2. 📋 Check node logs"
  echo "3. 🐾 Change fee"
  echo "4. 🛑 Stop node"
  echo "5. 🔄 Restart node"
  echo "6. 📈 Auto-restart node"
  echo "7. ✅ Update node"
  echo "8. 🗑️ Delete node"
  echo -e "9. 🚪 Exit script\n"
  read -p "Select menu item: " choice

  case $choice in
    1)
      download_node
      ;;
    2)
      check_logs
      ;;
    3)
      change_fee
      ;;
    4)
      stop_node
      ;;
    5)
      restart_node
      ;;
    6)
