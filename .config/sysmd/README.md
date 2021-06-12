## Autostart Syncthing as a service.

### NOTE: syncthing must be installed first.

```sh
sudo chown root: syncthing@.service
sudo cp -p syncthing@.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable syncthing@<user>
sudo systemctl start syncthing@<user>
```
