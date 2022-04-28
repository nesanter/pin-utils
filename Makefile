# Copyright © 2019 Noah Santer <personal@mail.mossy-tech.com>
#
# This file is part of pin-utils.
#
# pin-utils is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# pin-utils is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with pin-utils.  If not, see <https://www.gnu.org/licenses/>.

#### OPTIONS ####
## detect Windows build
SHELL=/bin/bash
ifeq ($(origin MINGW), undefined)
	ifeq ($(OS),Windows_NT)
		MINGW = 1
	else
		MINGW = 0
	endif
endif

### defaults ###
## Windows overrides
ifneq ($(MINGW),0)
	# no asan/usan
	NSANITIZE ?= 1
	# no termios.h
	PASSMODE ?= 0
endif

## Generic
PASSMODE ?= 1
NSANITIZE ?= 0
NDEBUG ?= 0
T9FLAGS ?=
T9OFLAGS ?= -DPASSMODE=$(PASSMODE) -DWERROR=1
T9PASSFLAGS ?= -DPASSMODE=$(PASSMODE) -DWERROR=1 -DTTYTEST=1 -DTTYREQUIRE=3
#---------------#

## aggregate (for flags check)
CHECKFLAGS =
CHECKFLAGS += CFLAGS='$(strip $(CFLAGS))'
CHECKFLAGS += LDFLAGS='$(strip $(LDFLAGS))'
CHECKFLAGS += NSANITIZE='$(strip $(NSANITIZE))'
CHECKFLAGS += NDEBUG='$(strip $(NDEBUG))'
CHECKFLAGS += T9FLAGS='$(strip $(T9FLAGS))'
CHECKFLAGS += T9OFLAGS='$(strip $(T9OFLAGS))'
CHECKFLAGS += T9PASSFLAGS='$(strip $(T9PASSFLAGS))'

## process options
ifneq ($(NSANITIZE),0)
	SANITIZE := -fno-sanitize=all
else
	SANITIZE := -fsanitize=address,undefined
endif

ALLFLAGS = -Wall
ifneq ($(NDEBUG),0)
	ALLFLAGS += -Werror -DNDEBUG -O2
else
	ALLFLAGS += -g -Og
endif
ALLFLAGS += $(SANITIZE) $(CFLAGS) $(LDFLAGS)
ALLFLAGS := $(strip $(ALLFLAGS))

#### files ####
### input ###
## common ##
ALLH = t9_table.h
ALLC = t9_table.c
## t9 ##
T9H := $(ALLH)
T9C := t9.c $(ALLC)
## t9o/t9pass ##
T9OH := $(ALLH)
T9OC := t9o.c $(ALLC)
### output ###
ALLBINS := t9 t9o t9pass
#--------------#

#### default target (all)
.PHONY: mkflags all
all: mkflags $(ALLBINS)

t9: flags.ignore $(T9H) $(T9C)
	$(CC) -o $@ $(T9C) $(ALLFLAGS) $(T9FLAGS)

t9o: flags.ignore $(T9OH) $(T9OC)
	$(CC) -o $@ $(T9OC) $(ALLFLAGS) $(T9OFLAGS)

t9pass: flags.ignore $(T9OH) $(T9OC)
	$(CC) -o $@ $(T9OC) $(ALLFLAGS) $(T9PASSFLAGS)

.PHONY: mkflags
.SILENT: mkflags
mkflags:
	cmp -s flags.ignore - <<< "$(strip $(CHECKFLAGS))" || { \
		echo "New compile flags: requires rebuild" ;\
		cat > flags.ignore <<< "$(strip $(CHECKFLAGS))" ;\
	}

.PHONY: clean
clean:
	rm -fv $(ALLBINS) flags.ignore

# .PHONY: install install-local
# install: all
# 	install -d $(DESTDIR)$(PREFIX)/usr/bin/
# 	install t9 $(DESTDIR)$(PREFIX)/usr/bin/
# 	install t9o $(DESTDIR)$(PREFIX)/usr/bin/
# 	install t9pass $(DESTDIR)$(PREFIX)/usr/bin/
#
# install-local: all
# 	install -d $(DESTDIR)$(PREFIX)/usr/local/bin/
# 	install t9 $(DESTDIR)$(PREFIX)/usr/local/bin/
# 	install t9o $(DESTDIR)$(PREFIX)/usr/local/bin/
# 	install t9pass $(DESTDIR)$(PREFIX)/usr/local/bin/
