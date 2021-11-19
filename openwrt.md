# OpenWRT

Configure DHCP:

```
config dhcp 'lan'
        list dhcp_option '6,192.168.1.xxx'
        list dhcp_option '119,dc.example.com'
```

Restart dnsmasq and DHCP

```
service dnsmasq restart
service odhcpd restart
```

Check logs: `logread`
