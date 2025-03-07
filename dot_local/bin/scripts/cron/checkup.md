# Checkup

Since we are using `notify-send`, adding `checkup` to the cronjob of root user
is not recommended, graphical notifications rely on access to the user's session
D-Bus and display ($DISPLAY) environment. Root does not naturally inherit these
variables, causing errors like "Broken pipe." and also you run into a bunch of
others problems and security risks if you try to run GUI's with root access.

So in order for the script to work properly, execute it as your user, but it
needs to run pacman,paru,etc as sudo without password requirement.

Archlinux installation script creates the wheel group, users in that group
can run any command, although it depends of the distro, some distros may do
`admin` for example. Run `sudo visudo` and un-comment:

```
# %wheel ALL=(ALL:ALL) NOPASSWD: ALL
```

Then of course add your user to the wheel group `usermod -aG wheel youruser`
(most likely it is part of that group if you choose to have your user as an
admin during installation)

However, `sudo visudo` and changing that line might don't do anything if you
have, `/etc/sudoers.d/00_youruser`, rules in that file take precedence over
`/etc/sudoers`, which is what `sudo visudo` modifies. And also I don't want to
be able to run any command without password, in case I'm doing something
potentially dangerous, being prompt for a password is like a reminder to be
careful with what you do, I just want to run pacman and an AUR helper without
password. For that:

```
youruser ALL=(ALL) ALL, NOPASSWD: /usr/bin/pacman, /usr/bin/paru
```

It can go in `/etc/sudoers`, but if you have `/etc/sudoers.d/00_youruser` then
put it there.
