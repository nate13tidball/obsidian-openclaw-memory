# EC2 OpenClaw Security Checklist

> Instance: `ip-172-31-22-52` | OS: Ubuntu (kernel 7.0.0-1004-aws) | Last audited: 2026-05-03

---

## 🟢 Already Done

- [x] OpenClaw gateway bound to `127.0.0.1` only (loopback)
- [x] OpenClaw token auth enabled, insecure auth disabled
- [x] Config directory `~/.openclaw` locked to `700` / files `600`
- [x] Unattended security upgrades active
- [x] No public ports except SSH (22)
- [x] OpenClaw ports (18789, 18791) only on localhost

---

## 🔴 Critical — Fix Now

### 1. SSH Password Authentication
**Status:** Likely enabled (not explicitly disabled in sshd_config)
```bash
# Disable password auth — SSH keys only
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

### 2. No Firewall (UFW not installed)
**Status:** ❌ No host-level firewall running
```bash
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp        # SSH (or your custom port)
sudo ufw enable
```

### 3. Fail2ban Not Running
**Status:** ❌ SSH brute-force protection is off
```bash
sudo apt install fail2ban -y
sudo systemctl enable --now fail2ban
# Config: /etc/fail2ban/jail.local
# Ban after 5 failed SSH attempts for 1 hour
```

### 4. Root Login Not Fully Disabled
**Status:** ⚠️ `prohibit-password` (default) — should be `no`
```bash
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

---

## 🟡 High Priority

### 5. SSH on Default Port 22
**Status:** ⚠️ Port 22 is world-facing and constantly scanned
- Consider moving SSH to a non-standard port (e.g. 2222) **or**
- Restrict SSH source IPs in the AWS Security Group to your home/VPN IPs only
```bash
# AWS Security Group: restrict inbound SSH to your IP only
# AWS Console → EC2 → Security Groups → Inbound Rules
# Type: SSH | Source: <your-ip>/32
```

### 6. AWS Security Group Audit
**Status:** Unknown — verify in AWS Console
- [ ] SSH (22) restricted to your IP(s) only — not `0.0.0.0/0`
- [ ] No other inbound ports open
- [ ] Outbound: review and restrict if possible

### 7. IAM Instance Role
**Status:** Unknown
- [ ] Instance should use an IAM role with least-privilege permissions
- [ ] No hardcoded AWS credentials anywhere on disk
```bash
# Check for hardcoded keys
grep -r "AKIA" ~/.* /home /etc 2>/dev/null | grep -v ".git"
```

### 8. `sync` User Has a Shell
**Status:** ⚠️ `sync` user has `/bin/sync` shell — should be `/usr/sbin/nologin`
```bash
sudo usermod -s /usr/sbin/nologin sync
```

---

## 🔵 Medium Priority

### 9. SSH Hardening (sshd_config)
```bash
# Add to /etc/ssh/sshd_config:
MaxAuthTries 3
LoginGraceTime 20
AllowUsers ubuntu openclaw        # whitelist only needed users
ClientAliveInterval 300
ClientAliveCountMax 2
X11Forwarding no
AllowTcpForwarding no
```

### 10. Enable CloudTrail (AWS-level)
- [ ] Enable AWS CloudTrail in your region for API audit logs
- [ ] Send logs to S3 with MFA-delete enabled
- [ ] Enable CloudWatch alarms for root login, security group changes

### 11. EBS Volume Encryption
**Status:** Unknown — verify in AWS Console
- [ ] Root EBS volume should be encrypted at rest
- [ ] Can be verified: EC2 → Volumes → Encryption column

### 12. Automatic Security Patching
**Status:** ✅ `unattended-upgrades` active — confirm config
```bash
cat /etc/apt/apt.conf.d/50unattended-upgrades | grep -i security
```

### 13. No Secrets in Environment / Disk
```bash
# Check for exposed secrets
env | grep -iE "key|secret|token|password"
cat ~/.bashrc ~/.profile | grep -iE "key|secret|token|password"
```

### 14. OpenClaw Credential Files
- [ ] `~/client_secret.json` (Google OAuth) should be deleted or moved to `~/.openclaw/credentials/`
- [ ] GitHub token should only exist in `~/.config/gh/hosts.yml` (already there)
```bash
# Clean up loose credential files
rm -f ~/client_secret.json /tmp/gog_token*.json
```

---

## 🟣 OpenClaw-Specific

### 15. Gateway Token Rotation
- [ ] Rotate OpenClaw gateway token periodically
- [ ] Token stored in `openclaw.json` — already `600` permissions ✅

### 16. Inbound Media Cleanup
- [ ] Files in `~/.openclaw/media/inbound/` include OAuth client secrets — clean up
```bash
ls ~/.openclaw/media/inbound/
# Delete any credential files after processing
```

### 17. Session Retention Policy
- [ ] Set `sessionRetention` to limit how long session transcripts are stored
```json5
{ gateway: { sessionRetention: "24h" } }
```

---

## 📋 Quick Audit Commands

```bash
# Open listening ports
ss -tlnp

# Failed SSH logins (last 50)
sudo journalctl -u ssh --no-pager | grep "Failed" | tail -50

# Last logins
last -20

# Currently logged in
who

# Check for suspicious cron jobs
crontab -l
sudo crontab -l

# World-writable files (bad)
find / -xdev -type f -perm -0002 2>/dev/null | grep -v proc

# SUID binaries (should be minimal)
find / -xdev -perm -4000 -type f 2>/dev/null
```

---

## Priority Order

| # | Check | Effort | Impact |
|---|-------|--------|--------|
| 1 | Disable SSH password auth | 2 min | 🔴 Critical |
| 2 | Install + enable UFW | 5 min | 🔴 Critical |
| 3 | Install + enable fail2ban | 5 min | 🔴 Critical |
| 4 | Disable root SSH login | 1 min | 🔴 Critical |
| 5 | Restrict SSH source IP in Security Group | 5 min | 🟡 High |
| 6 | Harden sshd_config | 10 min | 🟡 High |
| 7 | Clean up loose credential files | 2 min | 🟡 High |
| 8 | Audit IAM instance role | 10 min | 🟡 High |
| 9 | Enable CloudTrail | 15 min | 🔵 Medium |
| 10 | Verify EBS encryption | 2 min | 🔵 Medium |

---

*Sources: AWS Security Best Practices, AWS Well-Architected Security Pillar, CIS AWS Benchmarks, DigitalOcean Linux VPS Hardening*
