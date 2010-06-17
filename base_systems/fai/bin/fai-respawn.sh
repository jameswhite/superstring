#!/bin/bash
unset ISOIMAGE
unset USBIMAGE
SRV='/opt/local'

cat<<EOF > /etc/apt/sources.list
deb http://www.informatik.uni-koeln.de/fai/download experimental koeln
deb http://ftp.gtlib.gatech.edu/debian/ stable main non-free
deb http://security.debian.org/ stable/updates main non-free
EOF

apt-get update && apt-get upgrade

# fai package signing key
gpg --keyserver pgp.mit.edu -a --recv-keys AB9B66FD && \
gpg -a --export AB9B66FD | apt-key add - && \
apt-get install -y --force-yes apt-move fai-server fai-client mkisofs git-core

# make sure to use our sources.list for fai-setup or you won't get fai-3.2.23
cp /etc/apt/sources.list /etc/fai/apt/sources.list

# there isn't enough space in the gnome /srv, so we hack it.
[ -d /srv ] && /bin/rmdir /srv
[ ! -d ${SRV}/srv ] && mkdir -p ${SRV}/srv
[ ! -h /srv ] && ln -s ${SRV}/srv /srv

if [ ! -d /var/cache/git/superstring ];then
    if [ ! -d /var/cache/git ];then
        mkdir -p /var/cache/git
    fi
    (cd /var/cache/git ; git clone git://github.com/fapestniegd/superstring.git)
fi

[ ! -d /srv/fai/config ] && mkdir -p /srv/fai/config/
(cd /var/cache/git/superstring; git pull) && \
rsync -avzPH --delete /var/cache/git/superstring/base_systems/fai/config/ \
                      /srv/fai/config/

# Add cryptsetup to /etc/fai/NFSROOT
cp /etc/fai/NFSROOT /etc/fai/NFSROOT.dist
awk '{
      if($1=="PACKAGES"){
          if($2=="aptitude"){ print $0; print "cryptsetup" }else{ print $0; }
      }else{ print $0; }
     }' /etc/fai/NFSROOT.dist > /etc/fai/NFSROOT

fai-setup && fai-mirror /srv/fai/mirror

dpkg --root=/srv/fai/nfsroot/live/filesystem.dir/ \
     -l fai-client|awk '/fai-client/ {print $3}'

# fai-mirror expect the fai-configs to be populated, 
# so on the gnomehost vm:

fai-mirror /srv/fai/mirror

if [ ! ~z ${ISOIMAGE} ];then
    fai-cd  -fm /srv/fai/mirror /srv/fai/fai-cd-3.2.23.iso
fi

if [ ! ~z ${USBIMAGE} ];then
    [ ! -d /media/usbstick ] && mkdir -p /media/usbstick
    mke2fs /dev/sdb1 && \
    mount /dev/sdb1 /media/usbstick && \
    fai-cd  -m /srv/fai/mirror -u /media/usbstick && \
    cp /var/cache/git/superstring/base_systems/fai/grub/menu.lst \
       /media/usbstick/boot/grub && \
    umount /media/usbstick
fi

# Cryptoloop example:
# http://www.mail-archive.com/linux-fai@uni-koeln.de/msg01732.html

