# Copyright © 2019 Noah Santer <ncwbbzp9@protonmail.com>
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

ALLFLAGS=-Wall -Werror -fsanitize=address,undefined
TABLE=t9_table.c

T9ODEFS=
T9PASSDEFS=-DPASSMODE=1 -DTTYTEST=3 -DTTYREQUIRE=1

.PHONY: all
all: t9 t9o t9pass

t9: t9.c $(TABLE)
	$(CC) -o $@ $(CFLAGS) $(ALLFLAGS) $(LDFLAGS) $^ -Os

t9o: t9o.c $(TABLE)
	$(CC) -o $@ $(CFLAGS) $(ALLFLAGS) $(LDFLAGS) $^ $(T9ODEFS)

t9pass: t9o.c $(TABLE)
	$(CC) -o $@ $(CFLAGS) $(ALLFLAGS) $(LDFLAGS) $^ $(T9PASSDEFS)

.PHONY: clean
clean:
	rm -fv t9 t9o t9pass

.PHONY: install install-local
install: all
	install -d $(DESTDIR)$(PREFIX)/usr/bin/
	install t9 $(DESTDIR)$(PREFIX)/usr/bin/
	install t9o $(DESTDIR)$(PREFIX)/usr/bin/
	install t9pass $(DESTDIR)$(PREFIX)/usr/bin/

install-local: all
	install -d $(DESTDIR)$(PREFIX)/usr/local/bin/
	install t9 $(DESTDIR)$(PREFIX)/usr/local/bin/
	install t9o $(DESTDIR)$(PREFIX)/usr/local/bin/
	install t9pass $(DESTDIR)$(PREFIX)/usr/local/bin/

