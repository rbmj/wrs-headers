#!/usr/bin/env make

PREFIX="$(DESTDIR)/usr"
PROFDIR="$(DESTDIR)/etc/profile.d"

all:

install: generate profile

generate:
	./generate.sh DESTDIR=$(DESTDIR)

profile:
	install -d -o root -g root -m 755 "$(PROFDIR)"
	install -o root -g root -m 644 wrs_profile.sh "$(PROFDIR)"

