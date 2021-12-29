#!/bin/sh
apt-get update && apt-get install -yq gnupg2 wget lsb-release

dpkg -i depends/*.deb

apt-get update -y


./bootstrap.sh -j

./configure

make

make install

make all cd-sounds-install cd-moh-install

ln -s /usr/local/agnoconnect/bin/freeswitch /usr/bin/agnoconnect

ln -s /usr/local/agnoconnect/bin/fs_cli /usr/bin/as_cli

sudo groupadd agnoconnect

sudo adduser --quiet --system --home /usr/local/agnoconnect --gecos "agnoconnect open source softswitch" --ingroup agnoconnect agnoconnect --disabled-password

chown -R agnoconnect:agnoconnect /usr/local/agnoconnect/

chmod -R ug=rwX,o= /usr/local/agnoconnect/

chmod -R u=rwx,g=rx /usr/local/agnoconnect/bin/*

cp /usr/src/agnoconnect/debian/agnoconnect-systemd.agnoconnect.service /etc/systemd/system/agnoconnect.service

systemctl daemon-reload

systemctl start agnoconnect

exit 0
