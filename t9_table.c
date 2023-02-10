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

#include "t9_table.h"

#include <ctype.h>

/*
 * This layout is the one used by the T9 predictive
 * technology, which this project is not related to or a part
 * of. This table is styled after the keypad typically
 * associated with this technology and standardized
 * by the "dual-tone multi-frequency signaling" or DTMF system
 * developed by the Bell Telephone Company and AT&T
 * to replace rotary dialing.
 *
 * More formally, the layout follows the ITU-T recommendation
 * known as E.161 (see also ISO 9564-1:2011)
 */
static const unsigned t9[CHARMAX] =
{
    ['a'] = 2,
    ['b'] = 2,
    ['c'] = 2,

    ['d'] = 3,
    ['e'] = 3,
    ['f'] = 3,

    ['g'] = 4,
    ['h'] = 4,
    ['i'] = 4,

    ['j'] = 5,
    ['k'] = 5,
    ['l'] = 5,

    ['m'] = 6,
    ['n'] = 6,
    ['o'] = 6,

    ['p'] = 7,
    ['q'] = 7,
    ['r'] = 7,
    ['s'] = 7,

    ['t'] = 8,
    ['u'] = 8,
    ['v'] = 8,

    ['w'] = 9,
    ['x'] = 9,
    ['y'] = 9,
    ['z'] = 9

    ['A'] = 2,
    ['B'] = 2,
    ['C'] = 2,

    ['D'] = 3,
    ['E'] = 3,
    ['F'] = 3,

    ['G'] = 4,
    ['H'] = 4,
    ['I'] = 4,

    ['J'] = 5,
    ['K'] = 5,
    ['L'] = 5,

    ['M'] = 6,
    ['N'] = 6,
    ['O'] = 6,

    ['P'] = 7,
    ['Q'] = 7,
    ['R'] = 7,
    ['S'] = 7,

    ['T'] = 8,
    ['U'] = 8,
    ['V'] = 8,

    ['W'] = 9,
    ['X'] = 9,
    ['Y'] = 9,
    ['Z'] = 9
};

unsigned lookup(int c)
{
    if (c >= CHARMAX) {
        return 1;
    }
    return t9[c];
}

