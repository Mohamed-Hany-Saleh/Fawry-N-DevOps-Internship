# Q2 Reflective Report

## 1. Verifying DNS Resolution

First, I verified if `internal.example.com` can be resolved by the system's DNS server (`/etc/resolv.conf`) and compared it with Google's public DNS (`8.8.8.8`).

### Commands Used:
```bash
dig internal.example.com
dig @8.8.8.8 internal.example.com
```
![1](https://github.com/user-attachments/assets/8b9d3e1a-d8f5-49fa-b856-26b32b04031a)
- ![Screenshot DNS system]![2](https://github.com/user-attachments/assets/446a63c6-ef61-46dc-ae82-76be146b29b8)
- ![Screenshot DNS 8.8.8.8] ![3](https://github.com/user-attachments/assets/81404f93-4ae4-492e-b4e2-8b55091c2063)

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

- ![Screenshot service reachability]![4](https://github.com/user-attachments/assets/31aca173-8b3f-4153-ae03-9525ef4e9b17)

- ![Screenshot listening ports]file:///home/mohammed/fawry/Fawry%20N%C2%B2%20DevOps%20Internship/Scenario/5.png


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

- ![Screenshot hosts file]
  ![6](https://github.com/user-attachments/assets/b26d63e7-c6f1-455e-b129-eca64761598e)
  ![7](https://github.com/user-attachments/assets/b6fb2c3a-cb6a-4ef1-af3c-69b3b8faad68)
  ![8](https://github.com/user-attachments/assets/ba71f125-9f78-45ba-928d-56810da3e0d0)



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

- ![Screenshot DNS persist]
  ![10](https://github.com/user-attachments/assets/4d5c1a2f-429c-4b5b-8781-ef2d7a0c825d)
  ![11](https://github.com/user-attachments/assets/6749f644-e84a-4b6b-ad83-82c2e54aa3f8)
  ![12](https://github.com/user-attachments/assets/52a3b834-0a7c-43a4-a40b-ed4f74657f17)
  ![13](https://github.com/user-attachments/assets/7bca2db9-2908-4a06-8f9f-a966b41efbbd)
  ![14](https://github.com/user-attachments/assets/9ae5031b-0097-48fc-8576-cbb68879b4df)
  ![15](https://github.com/user-attachments/assets/35d4dabe-d3d4-4ff4-879b-33e2f9b76880)








---

# ✅ Summary

- Diagnosed DNS resolution issues.
- Diagnosed service reachability.
- Listed full possible causes.
- Provided specific commands to confirm and fix each issue.
- Added bonus sections for best practices.

