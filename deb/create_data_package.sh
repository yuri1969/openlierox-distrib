#!/bin/bash

echo Creating openlierox-data.deb
if [ -e pkg ] ; then rm -rf pkg ; fi
mkdir -p pkg/usr/share/games
cp -r data/share pkg/usr
gzip -c -9 ../../doc/ChangeLog > pkg/usr/share/doc/openlierox-data/changelog.gz
if [ -e ../../share/gamedir/front.bmp ] ; then rm ../../share/gamedir/front.bmp ; fi
if [ -e ../../share/gamedir/back.bmp ] ; then rm ../../share/gamedir/back.bmp ; fi

cp -r ../../share/gamedir pkg/usr/share/games/OpenLieroX
find pkg/ -name ".svn" -exec rm -rf {} \; >/dev/null 2>&1
find pkg/ -name "*~" -exec rm -rf {} \; >/dev/null 2>&1

find pkg/ -type "f" -exec md5sum {} \; | sed 's@ pkg/@ @' > md5sums

mkdir pkg/DEBIAN
mv md5sums pkg/DEBIAN
find data -maxdepth 1 -type "f" -exec cp {} pkg/DEBIAN \;

# TODO: this is a bad hack and has to be done somehow different
# You should be member of "root" group to execute this
chown -R root:root pkg/

Version=`cat ../../VERSION | sed 's/_/./g'`
Size=`du -k -s pkg | grep -o '[0-9]*'`
cat data/control | \
sed "s/^Version:.*/Version: $Version/" | \
sed "s/^Installed-Size:.*/Installed-Size: $Size/" \
> pkg/DEBIAN/control

dpkg -b pkg openlierox-data_$Version.deb

rm -rf pkg
