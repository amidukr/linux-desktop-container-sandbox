
Set global variabes:
```bash
export CONTAINERS_FOLDER=~/Containers
export CONTAINER_IMAGE=arch-box
export CONTAINER_USER=demo
```

Install Container and initialize Containers script
``` bash
mkdir $CONTAINERS_FOLDER
git clone https://github.com/amidukr/linux-desktop-container-sandbox.git \
        $CONTAINERS_FOLDER/scripts

$CONTAINERS_FOLDER/scripts/init.sh
```

Build arch-box container:
```bash

$CONTAINERS_FOLDER/scripts/build-arch-box.sh
$CONTAINERS_FOLDER/scripts/extract-arch-box.sh
```

Let's check permissions for just a user
```bash

# Shell into container user regular user

$CONTAINERS_FOLDER/scripts/run-arch-box-user.sh

# Let's try to write file to home directory
echo Hello World> ~/file.txt
# Should succeed

#Let's try to do the same with root directory
echo Hello World> /file.txt
# Will fail because root fs mounted as readonly, expected behaviour

# If just run kentwalk, it should fail since package not installed yet
knetwalk

# Let's try to run pacman package manage
pacman -Sy knetwalk
# Should fail by complaining that operation needs to be run from sudo

# Let's try sudo
sudo pacman -Sy knetwalk
# Sudo should execute command under container root, however system would complain about different permissions issue

exit
```

Same check by for admin user:
```bash
$CONTAINERS_FOLDER/scripts/run-arch-box-admin.sh


echo Hello World> ~/file.txt
echo Hello World> /file.txt
knetwalk
pacman -Sy knetwalk

# All this command above should work or fail similarly as for simple user

exit
```


Installing knetwalk from admin user:
```
$CONTAINERS_FOLDER/scripts/run-arch-box-admin.sh

sudo pacman -Sy knetwalk
sudo pacman -Sy noto-fonts

# And running should work now
export $(dbus-launch)
knetwalk 

exit
```

And running knetwalk from unprivileged user
```
$CONTAINERS_FOLDER/scripts/run-arch-box-user.sh

# Just same again
export $(dbus-launch)
knetwalk 

exit

```

And finally let's check how much space totally was used:

```bash
du -h -d 1 $CONTAINERS_FOLDER 2>/dev/null
```
