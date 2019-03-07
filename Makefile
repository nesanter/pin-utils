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

CFLAGS=-Wall -Werror -fsanitize=address,undefined
TABLE=t9_table.c

T9ODEFS=
T9PASSDEFS=-DPASSMODE=1 -DTTYTEST=3 -DTTYREQUIRE=1

.PHONY: all
all: t9 t9o t9pass

t9: t9.c $(TABLE)
	$(CC) -o $@ $(CFLAGS) $^ -Os

t9o: t9o.c $(TABLE)
	$(CC) -o $@ $(CFLAGS) $^ -Og -g $(T9ODEFS)

t9pass: t9o.c $(TABLE)
	$(CC) -o $@ $(CFLAGS) $^ -Os $(T9PASSDEFS)

.PHONY: clean
clean:
	rm -fv t9 t9o t9pass
