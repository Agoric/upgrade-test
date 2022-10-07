#!/bin/bash
BINARY=${BINARY:-agd}
STATEDIR=${STATEDIR:-netstate}
$BINARY start --pruning=nothing --home "$STATEDIR"
