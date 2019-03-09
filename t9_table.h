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

#ifndef T9_TABLE_H
#define T9_TABLE_H

#include <stddef.h>

#ifndef CHARMAX
#define CHARMAX 128
#endif

#if CHARMAX < 0
#error "CHARMAX must be > 0"
#endif

#ifndef UPPER_TO_LOWER
#if CHARMAX <= 256
#define UPPER_TO_LOWER 1
#endif
#endif

size_t lookup(int c);

#endif /* T9_TABLE_H */
