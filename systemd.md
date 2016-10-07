# Systemd

A new unit needs to add itself as a dependency of a unit of the boot sequence (multi-user.target).

Services which want to start during boot need an `[Install]` section with a `WantedBy=multi-user.target` (equivalent to `start on runlevel [2345]` in upstart).

Use `systemd-analyze verify <unit>` to get warnings on invalid configurations.

## Override default units

Create a unit drop-in file at `/etc/systemd/system/<unit>.d/<name>.conf`

## Environment configuration

```
[Service]
EnvironmentFile=/etc/default/myservice
ExecStart=/usr/bin/mydaemon --port=$PORT
```

To make EnvironmentFile optional:

```
EnvironmentFile=-/etc/default/myservice
```

## Commands

```
systemctl start|stop|restart|status|enable|disable <unit>
```

View log:

```
sudo journalctl -u <unit>
```

Tail log:

```
sudo journalctl -u <unit> -f
```

Show depdendencies:

```
systemctl list-dependencies --all
```
