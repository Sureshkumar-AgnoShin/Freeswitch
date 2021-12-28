#!/bin/sh
#wget  https://github.com/freeswitch/sofia-sip

./dep.sh

apt-get update -y

apt-get build-dep freeswitch -y

./bootstrap.sh -j

./configure

make

make install

make all cd-sounds-install cd-moh-install

ln -s /usr/local/agnoconnect/bin/agnoconnect /usr/bin/agnoconnect

#ln -s /usr/local/agnoconnect/bin/fs_cli /usr/bin/fs_cli

cd /usr/local

mv /usr/local/agnoconnect/run/freeswitch.pid /usr/local/agnoconnect/run/agnoconnect.pid
sudo groupadd agnoconnect

sudo adduser --quiet --system --home /usr/local/agnoconnect --gecos "agnoconnect open source softswitch" --ingroup agnoconnect agnoconnect --disabled-password

chown -R agnoconnect:agnoconnect /usr/local/agnoconnect/

chmod -R ug=rwX,o= /usr/local/agnoconnect/

chmod -R u=rwx,g=rx /usr/local/agnoconnect/bin/*

cp /usr/src/agnoconnect/debian/agnoconnect-systemd.agnoconnect.service /etc/systemd/system/agnoconnect.service

systemctl daemon-reload

systemctl start agnoconnect

exit 0
