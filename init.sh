#!/bin/bash
BINARY=${BINARY:-ag0}
STATEDIR=${STATEDIR:-netstate}
CHAINID=${CHAINID:-localchain-1}

rm -rf $STATEDIR

$BINARY init localnet --home "$STATEDIR" --chain-id $CHAINID
$BINARY keys add validator --keyring-backend test --home "$STATEDIR" 
export GENACCT=$($BINARY keys show validator -a --keyring-backend="test" --home "$STATEDIR")
contents=$(jq '. * { app_state: { gov: { voting_params: { voting_period: "10s" } } } }' "$STATEDIR/config/genesis.json") && echo -E "${contents}" > "$STATEDIR/config/genesis.json"

# Build genesis file incl account for passed address
coins="10000000000stake,100000000000samoleans"
$BINARY add-genesis-account $($BINARY keys show validator -a --keyring-backend="test" --home "$STATEDIR") $coins
$BINARY add-genesis-account $GENACCT $coins --home "$STATEDIR"
$BINARY gentx validator 5000000000stake --keyring-backend="test" --chain-id $CHAINID  --home "$STATEDIR"
$BINARY collect-gentxs --home "$STATEDIR"

$BINARY start --pruning=nothing --home "$STATEDIR"