# Wormycrypt
Increase confidence that the file sent through wormhole was untouched

## Dependencies

Fish Shell
https://github.com/fish-shell/fish-shell
```
apt install fish
```

Magic Wormhole
https://github.com/magic-wormhole/magic-wormhole
```
apt install magic-wormhole
```

## Run
`. wormycrypt.sh <file>`

## How to use

Run the script
`. wormycrypt.sh <file>`

Enter password for gpg sysmetric encryption when prompted


Receive as normal on target device `wormhole receive <code>`

When received on target ***before*** decrypting `sha256sum <file-received.tar.gz.gpg>`

Check the SHA256 hash printed out by the sending script against the hash on the target


Use gpg to decrypt `gpg -d <file-received.tar.gz.gpg>`

Open archive `tar -xzf <file-received.tar.gz>`
