# Autostart Syncthing as a service.

```sh
sudo cp -p syncthing@.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable syncthing@<user>
sudo systemctl start syncthing@<user>
```
