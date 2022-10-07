#!/bin/bash
BINARY=${BINARY:-ag0}
STATEDIR=${STATEDIR:-netstate}
CHAINID=${CHAINID:-localchain-1}
UPGRADETO=${UPGRADETO:-agoric-upgrade-8}

$BINARY tx distribution withdraw-all-rewards --from=validator --chain-id $CHAINID --yes --home "$STATEDIR" --keyring-backend test -bblock
latest_height=$($BINARY status | jq -r .SyncInfo.latest_block_height)
height=$(( $latest_height + 6 ))
$BINARY tx gov submit-proposal software-upgrade $UPGRADETO --upgrade-height="$height" --title="Upgrade to ${UPGRADETO}" --description="upgrades" --from=validator --chain-id="$CHAINID" -bblock --yes --keyring-backend test --home "$STATEDIR" 
proposal=1 

$BINARY tx gov deposit $proposal 10000000stake --from=validator --chain-id="$CHAINID" -bblock --yes --home "$STATEDIR" --keyring-backend test
$BINARY tx gov vote $proposal yes --from=validator --chain-id="$CHAINID" --yes  --home "$STATEDIR" --keyring-backend test

# check status of proposal
watch "$BINARY q gov proposal $proposal -ojson | jq ."

