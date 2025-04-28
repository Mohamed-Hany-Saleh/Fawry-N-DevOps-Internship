# Q2 Reflective Report

## 1. Verifying DNS Resolution

First, I verified if `internal.example.com` can be resolved by the system's DNS server (`/etc/resolv.conf`) and compared it with Google's public DNS (`8.8.8.8`).

### Commands Used:
```bash
dig internal.example.com
dig @8.8.8.8 internal.example.com
```

- ![Screenshot DNS system](path/to/screenshot1.png)
- ![Screenshot DNS 8.8.8.8](path/to/screenshot2.png)

> **Analysis:**  
> If resolution with the local DNS fails but works with 8.8.8.8, it indicates an issue with the internal DNS server settings.

---

## 2. Diagnosing Service Reachability

After resolving the IP address, I checked whether the web server is reachable on ports 80 (HTTP) or 443 (HTTPS).

### Commands Used:
```bash
telnet <resolved_IP> 80
telnet <resolved_IP> 443
curl -I http://internal.example.com
ss -tuln | grep ':80\|:443'
```

- ![Screenshot service reachability](path/to/screenshot3.png)
- ![Screenshot listening ports](path/to/screenshot4.png)

> **Analysis:**  
> If connection refused or no response → Web server or firewall/network issues exist.  
> If connected successfully → DNS only issue.

---

## 3. Listing Possible Causes for the Issue

| Cause | Description |
|:------|:------------|
| Wrong or missing DNS record | DNS server does not have the correct A record |
| Misconfigured `/etc/resolv.conf` | System is pointing to wrong DNS server |
| DNS server outage | Internal DNS server is down |
| Firewall blocking DNS queries | Port 53 (DNS) blocked |
| Firewall blocking HTTP/HTTPS | Ports 80/443 blocked |
| Web server misconfiguration | Web service is not bound to correct IP/Port |
| Routing/network issue | Path between client and server is broken |

---

## 4. Proposed Fixes and Commands

| Issue | How to Confirm | Fix Command |
|:------|:---------------|:------------|
| Wrong/missing DNS record | `dig internal.example.com` returns no result | Update DNS zone file or add correct A record |
| `/etc/resolv.conf` misconfigured | Check `cat /etc/resolv.conf` | Edit `/etc/resolv.conf` and set correct DNS server IP |
| DNS server down | `ping DNS_SERVER_IP` or `dig` fails | Restart DNS server service (`systemctl restart named`) |
| Firewall blocking DNS | `telnet DNS_SERVER_IP 53` fails | Allow port 53 on firewall (`firewall-cmd --add-port=53/udp`) |
| Firewall blocking HTTP/HTTPS | `telnet SERVER_IP 80/443` fails | Allow ports 80/443 (`firewall-cmd --add-port=80/tcp --add-port=443/tcp`) |
| Web server misconfigured | `ss -tuln` shows no 80/443 ports | Restart web server (`systemctl restart apache2` or `nginx`) |
| Routing problem | `traceroute SERVER_IP` shows breaks | Fix network routes or VPN configs |

---

## 5. Bonus Section

### Bypassing DNS using `/etc/hosts`
To bypass DNS resolution temporarily:

```bash
sudo nano /etc/hosts
```
Add:
```
192.168.x.x internal.example.com
```

- ![Screenshot hosts file](path/to/screenshot5.png)

### Persisting DNS Settings

**For systemd-resolved:**
```bash
sudo nano /etc/systemd/resolved.conf
# Set DNS=8.8.8.8 or your internal DNS
sudo systemctl restart systemd-resolved
```

**For NetworkManager:**
```bash
nmcli dev show | grep DNS
nmcli con mod <connection-name> ipv4.dns "8.8.8.8"
nmcli con up <connection-name>
```

- ![Screenshot DNS persist](path/to/screenshot6.png)

---

# ✅ Summary

- Diagnosed DNS resolution issues.
- Diagnosed service reachability.
- Listed full possible causes.
- Provided specific commands to confirm and fix each issue.
- Added bonus sections for best practices.

