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
