# fokus

A **system-level website blocker** for Linux. Blocks domains by modifying the `/etc/hosts` file and freezes it afterward—works independently of browser, VPN, or browser extensions.

Compatible with **ext4** and **btrfs**, tested on Arch-based distributions.

---

## Requirements

- Linux with Python 3.6+
- `sudo` privileges
- `e2fsprogs` for `chattr` (ext4 only — usually pre-installed)

---

## Installation

```bash
bash install.sh
```

The script automatically detects your filesystem, copies `fokus.py` to `/usr/local/bin/fokus`, and creates a backup of your hosts file at `/etc/hosts.backup`.

---

## Usage

```bash
sudo fokus start            # Enable blocking
sudo fokus stop             # Disable blocking
sudo fokus lock <minutes>   # Prevent "stop" for X minutes
fokus status                # Show current status
```

### Examples

```bash
sudo fokus start        # Enable blocking
sudo fokus lock 90      # Prevent "stop" for 90 minutes
fokus status            # Display remaining lock time
sudo fokus stop         # Fails while lock is active
sudo fokus lock 0       # Remove lock immediately (emergency)
sudo fokus stop         # Now works
```

---

## Configuring Blocked Domains

Blocked domains are defined in the file `**/etc/fokus.conf**`. If the file does not exist, it will be created automatically with default domains (e.g., YouTube, Instagram).

### Recommendation:

Always include all variants of a domain, such as:

- `example.com`
- `www.example.com`
- `m.example.com`

No reinstallation is needed after editing the config file.

---

## How It Works

### **Blocking:**

When you run `fokus start`, all domains from `/etc/fokus.conf` are added to `/etc/hosts` and redirected to `127.0.0.1` (your local machine). The operating system reads this file before any DNS lookup, so the domain is redirected to "nowhere" before any network traffic is sent.

### **Immutable Protection:**

After any change, the hosts file is protected:

- **ext4:** via `chattr +i` — even root cannot edit the file
- **btrfs:** via `chmod 444` + root ownership — equivalent protection

### **Lock:**

The command `fokus lock <minutes>` writes a Unix timestamp to `/etc/fokus.lock` and freezes that file as well. As long as the time has not elapsed, the `stop` command will refuse to execute. Use `lock 0` in an emergency to remove the lock immediately.

---

## Uninstallation

```bash
sudo fokus stop                      # Disable blocking (if active)
sudo rm /usr/local/bin/fokus         # Remove the script
sudo rm -f /etc/fokus.lock           # Remove the lock file (if present)
sudo rm -f /etc/fokus.conf           # Remove the config file
```

---

## Restoring the hosts File

If something goes wrong:

```bash
# ext4
sudo chattr -i /etc/hosts
sudo cp /etc/hosts.backup /etc/hosts

# btrfs
sudo chmod 644 /etc/hosts
sudo cp /etc/hosts.backup /etc/hosts
```
