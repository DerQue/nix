# Secrets

Managed with [agenix](https://github.com/ryantm/agenix). Secrets are age-encrypted and safe to commit.

## How it works

Each `.age` file is encrypted with the public keys listed in `secrets.nix`. At boot, NixOS/nix-darwin decrypts them using the machine's SSH host key and places them in `/run/agenix/` (RAM only).

## Prerequisites

Your SSH private key must be at `~/.ssh/id_ed25519` (restore from Bitwarden if on a fresh machine).

## Edit an existing secret

```bash
cd ~/.nix
nix run github:ryantm/agenix -- -e secrets/<name>.age
```

This opens `$EDITOR`. Save and quit to re-encrypt.

## Add a new secret

**1. Create the `.age` file entry in `secrets.nix`:**

```nix
"my-secret.age".publicKeys = [ gaming quentin ];  # or [ macbook quentin ]
```

**2. Encrypt it:**

```bash
nix run github:ryantm/agenix -- -e secrets/my-secret.age
```

**3. Reference it in a NixOS/darwin module:**

```nix
age.secrets.my-secret.file = ../../secrets/my-secret.age;

# Then use:
config.age.secrets.my-secret.path  # → /run/agenix/my-secret
```

**4. Commit the `.age` file.**

## Add a new machine

**1.** Generate the host key on the new machine (or during install):
```bash
sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
cat /etc/ssh/ssh_host_ed25519_key.pub
```

**2.** Add the public key to `secrets.nix`:
```nix
newhost = "ssh-ed25519 AAAA...";
```

**3.** Re-encrypt all secrets that the new machine should access:
```bash
nix run github:ryantm/agenix -- -e secrets/some-secret.age
```

**4.** Commit and rebuild.

## Current secrets

| File | Used by | Contents |
|---|---|---|
| `gaming-password.age` | `hosts/gaming/default.nix` | Hashed login password |
| `macbook-wireguard.age` | `hosts/macbook/wireguard.nix` | WireGuard private key |
