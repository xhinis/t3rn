#!/bin/bash

update_node() {
  delete_node

  if [ -d "$HOME/executor" ] || screen -list | grep -q "\.t3rnnode"; then
    echo 'The executor folder or t3rnnode session already exists. Installation is not possible. Choose to delete the node or exit the script.'
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
  export EXECUTOR_MAX_L3_GAS_PRICE=500
  export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API="false"

  cd $HOME/executor/executor/bin/

  screen -dmS t3rnnode bash -c '
    echo "Script started in screen session"

    cd $HOME/executor/executor/bin/
    ./executor

    exec bash
  '

  echo "Screen session 't3rnnode' created, and node started..."
}

change_fee() {
    echo 'Changing the gas fee...'

    if [ ! -d "$HOME/executor" ]; then
        echo 'Executor folder not found. Install the node first.'
        return
    fi

    read -p 'What gas price (GWEI) do you want to set? (default is 500) ' GWEI_SET

    cd $HOME/executor
    export EXECUTOR_MAX_L3_GAS_PRICE=$GWEI_SET

    echo 'Restarting the node...'

    restart_node

    echo 'The gas fee has been updated.'
}
