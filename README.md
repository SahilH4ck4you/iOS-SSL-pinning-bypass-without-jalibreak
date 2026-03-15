# SSL Pinning Bypass for iOS — iptables

A collection of bash scripts for setting up an OpenVPN server with iptables rules to intercept and redirect iOS traffic for SSL pinning bypass during security research and penetration testing.

---

## ⚠️ Disclaimer

These tools are intended **for authorized security research, penetration testing, and educational purposes only**. Do not use on any device or network without explicit permission.

---

## 📁 Scripts

### 1. `openvpn-install.sh`
Automated OpenVPN server installer based on [Nyr/openvpn-install](https://github.com/Nyr/openvpn-install).

**Supports:** Ubuntu 22.04+, Debian 11+, AlmaLinux/Rocky/CentOS 9+, Fedora

**Features:**
- Full OpenVPN server setup with PKI (via easy-rsa)
- Supports UDP and TCP
- Configurable DNS (Google, Cloudflare, OpenDNS, Quad9, AdGuard, custom)
- Manages iptables/firewalld rules automatically
- Add/revoke clients without reinstalling

**Usage:**
```bash
chmod +x openvpn-install.sh
sudo bash openvpn-install.sh
```

---

### 2. `iptables-setup.sh`
Sets up iptables NAT rules to redirect HTTP/HTTPS traffic from the VPN tunnel (`tun0`) to a local proxy (port `8080`) — useful for tools like Burp Suite or mitmproxy.

**What it does:**
- Redirects port `80` → `8080` on `tun0`
- Redirects port `443` → `8080` on `tun0`
- Adds MASQUERADE rule for the given subnet on `eth0`

**Usage:**
```bash
chmod +x iptables-setup.sh
sudo bash iptables-setup.sh <VPN_SERVER_IP>

# Example:
sudo bash iptables-setup.sh 10.8.0.1
```

---

## 🔧 Typical Setup Flow

1. Run `openvpn-install.sh` to set up your VPN server
2. Connect your iOS device to the VPN
3. Run `iptables-setup.sh` with your VPN server IP to redirect traffic to your proxy
4. Configure your proxy tool (e.g., Burp Suite) to listen on port `8080`
5. Install your proxy's CA certificate on the iOS device
6. Use a Frida/objection script or similar to bypass SSL pinning on the target app

---

## 📋 Requirements

- Linux server (root access)
- `iptables`
- OpenVPN (installed via `openvpn-install.sh`)
- A proxy tool (Burp Suite, mitmproxy, etc.) listening on port `8080`

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
