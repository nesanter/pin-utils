/* Copyright © 2019 Noah Santer <ncwbbzp9@protonmail.com>
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

#ifdef __MINGW64__
#define __USE_MINGW_ANSI_STDIO 1
#endif

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <string.h>

/*** CONFIG DEFINES
 *
 * PASSMODE [no]: getpass-like behavior if stdin is a tty
 * TTYREQUIRE [b11],
 * TTYTEST [b00]: bitfields
 *  1s bit: MASK set requires stdin tty-ness to match REQUIRE (set=yes)
 *  2s bit: as above for stdout
 *
 * (from t9_table.h)
 * UPPER_TO_LOWER [yes]: auto-convert uppercase to lowercase
 * 
 * -- advanced --
 * CHARMAX: (see also t9_table.h) size of T9 table, generally 
 *
 ***/

#if PASSMODE
#include <termios.h>
#endif

#include "t9_table.h"

#ifndef TTYREQUIRE
/***
 * require both by default
 * only according to TTYTEST mask
 *
 * (n.b. needs to be set so can't just invert)
 ***/
#define TTYREQUIRE 3
#endif

extern size_t t9[CHARMAX];

static void emit(size_t x)
{
    if (isatty(1)) {
        int n = snprintf(NULL, 0, "%zu", x);
        char * s = malloc(n + 1);
        snprintf(s, n + 1, "%zu", x);

        n += n % 2;
        for (int i = 0; i < n; i += 2) {
            if (i > 0) {
                putchar(' ');
            }
            putchar(s[i]);
            putchar(s[i + 1] ?: '-');
        }
        putchar('\n');

        free(s);
    } else {
        printf("%zu\n", x);
    }
}

#if PASSMODE
static struct termios old, new;

static void passoff()
{
    (void)tcsetattr(0, TCSAFLUSH, &old);
}

static void passon()
{
    if (tcgetattr(0, &old) != 0) {
        fprintf(stderr, "PASSMODE get failed.\n");
        exit(1);
    }
    new = old;
    new.c_lflag &= ~ECHO;
    if (tcsetattr(0, TCSAFLUSH, &new) != 0) {
        fprintf(stderr, "PASSMODE set failed.\n");
        exit(1);
    }
    atexit(&passoff);
}
#endif

int main(int argc, char ** argv)
{
    size_t x = 0,
           bits = sizeof(x) * 8,
           t;

#if TTYTEST

#if TTYREQUIRE & 1
#define TTY1NOT " not "
#else
#define TTY1NOT " "
#endif

#if TTYREQUIRE & 2
#define TTY2NOT " not "
#else
#define TTY2NOT " "
#endif

#endif /* TTYTEST */


#if TTYTEST & 1
    if (((TTYREQUIRE & 1) ? 0 : 1) == isatty(0)) {
        fprintf(stderr, "Error: stdin is" TTY1NOT "a TTY\n");
        exit(1);
    }
#endif

#if TTYTEST & 2
    if (((TTYREQUIRE & 2) ? 0 : 1) == isatty(1)) {
        fprintf(stderr, "Error: stdout is" TTY2NOT "a TTY\n");
        exit(1);
    }
#endif

#if PASSMODE
    if (isatty(0)) {
        passon();
    }
#endif

    for (size_t i = 0, line = 1; ; i += 3) {
        int c;

        while ((c = getchar()) == EOF || c == '\n') {
            if (i > 0) {
                emit(x);
                x = 0;
                i = 0;
            }

            if (c == EOF) {
                return 0;
            }

            line++;
        }

#if WERROR
#define INVALIDSTR "Error"
#else
#define INVALIDSTR "Warning"
#endif

        if (i > bits) {
            fprintf(stderr, INVALIDSTR ": input line %zu exceeds wrap length %zu\n", line, bits / 3);
#if WERROR
            return 1;
#endif
            i %= bits;
        }

        t = lookup(c);

        if (t < 2) {
            fprintf(stderr, INVALIDSTR ": invalid input at %zu (line %zu): '%c' (x%x)\n", i / 3, line, isprint(c) ? c : '\0', c);
#if WERROR
            return 1;
#endif
        }

        x |= (t - 2) << i;
    }
}

