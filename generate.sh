#!/bin/sh

set -e

PREFIX="/usr"
WIND_BASE="$PREFIX/powerpc-wrs-vxworks/wind_base"
TOOL_DIR="$PREFIX/powerpc-wrs-vxworks"
TMP_DIR=`mktemp -t -d wrs-headers-installer.XXXXXXXXXX` || exit 1
CONF_DIR="$PREFIX/share/wrs-headers"
LDSCRIPT_DIR="$TOOL_DIR/share/ldscripts"
GCCDIST_URL="http://download.ni.com/pub/devzone/tut/updated_vxworks63gccdist.zip"

#create directories
mkdir -p "$DESTDIR$WIND_BASE"
mkdir -p "$DESTDIR$TOOL_DIR"
mkdir -p "$DESTDIR$WIND_BASE/target"
mkdir -p "$DESTDIR$CONF_DIR"
mkdir -p "$DESTDIR$LDSCRIPT_DIR"

#download gccdist and unzip
echo -n "Downloading gccdist... "
wget -q "$GCCDIST_URL" -O "$TMP_DIR/gccdist.zip"
echo "done."

#extract
echo -n "Extracting... "
unzip -qo "$TMP_DIR/gccdist.zip" -d "$TMP_DIR"
echo "done."

#Generate package
echo "Generating... "

echo -n "Copying scripts... "
SCRIPT_LOC="$TMP_DIR/gccdist/WindRiver/vxworks-6.3/host"
cp -R "$SCRIPT_LOC" "$DESTDIR$WIND_BASE"
echo "done."

echo -n "Copying headers... "
HEADER_LOC="$TMP_DIR/gccdist/WindRiver/vxworks-6.3/target/h"
mkdir -p "$DESTDIR$TOOL_DIR/sys-include"
cp -R "$HEADER_LOC/." "$DESTDIR$TOOL_DIR/sys-include"
echo "done."

#make symlink to headers
mkdir -p "$DESTDIR$WIND_BASE/target"
ln -fs "$TOOL_DIR/sys-include/wrn/coreip" \
    "$DESTDIR$TOOL_DIR/wind_base/target/h" 

#Add in a link script
sed '/ENTRY(_start)/d' \
    < "$HEADER_LOC/tool/gnu/ldscripts/link.OUT" \
    > "$DESTDIR$LDSCRIPT_DIR/dkm.ld"

echo "Package generation complete."

#clean up
rm -rf $TMP_DIR

