/* Copyright © 2019 Noah Santer <personal@mail.mossy-tech.com>
 *
 * This file is part of pin-utils.
 * 
 * pin-utils is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * pin-utils is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with pin-utils.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <stdio.h>

#include "t9_table.h"

int main(int argc, char ** argv)
{
    int err = 0;
    int c;

    while ((c = getchar()) != EOF) {
        if (c == '\n') {
            putchar(c);
            continue;
        }
        size_t t = lookup(c);
        if (t < 2) {
            fprintf(stderr, "invalid: %x\n", c);
            err = 1;
            putchar('!');
            continue;
        }
        putchar(t + '0');
    }
    return err;
}

