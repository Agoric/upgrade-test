# Upgrade-test

to use, ensure the params in init.sh and post.sh are correct, or override them like so

```sh
BINARY=agd ./init.sh
```

```sh
BINARY=agd UPGRADETO=agoric-upgrade-8 ./propose.sh
```

```sh
BINARY=agd ./post.sh
```
