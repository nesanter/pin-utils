# `pin-utils`: PIN Utilies

There are two utilities included here: *t9* and *t9o*.
Both of them map input strings to numeric PIN-style codes using a system derived from the T9 number-to-letter mapping common on older phones.
[Diagram](https://upload.wikimedia.org/wikipedia/commons/7/73/Telephone-keypad2.svg)

The intended purpose of both is to facilitate mnemonics for numeric PIN code generation.
 The motivating factor here is that when prompted to enter a (commonly 4 or 6) digit pin, most users even if aware of standard password sanity rules are at a disadvantage.
The three major concerns are: heavy PIN reuse, likelihood of meaningful PINs (aniversary, birthday, etc.), and difficulty remembering meaningless ones (thus, heavy write-downing.)

These tools assist by generating numeric PINs from more memorable alphabetical strings. They are lossy asymmetric encoders best used not for secure/cryptographic generation but instead for inspiration and as memorization aides.

## Example Use

User is asked to provide a 4-digit numeric PIN for a new application but does not want to use their traditional one (i.e. their and their partner's 2-digit birth years) but also doesn't want to forget it or have to write it on a sticky-note next to their monitor. Instead, they choose to use *t9*.

Using their terminal and the standard utility (cleverly named `t9`) User's session looks something like this:

```
thom
8466
tomato
866286
bird
2473
```

Here, User has tried three mnemonics (*thom*, *tomato*, and *bird*) which each yielded numeric pins.
Using `t9` there will always be one output digit per input character but User is free to simply remember that, for example, only the first (or last or middle, etc.) digits of a word are used.

User picks *bird* as their mnemonic and enters *2473* as their PIN.

Ten minutes later, User is asked to enter the PIN again but has unfortunately forgotten it. They do remember using `t9`, though, and that it was an animal... bird! That'd be it. Using their terminal again, a simple `t9 <<< "bird"` informs them their PIN was *2473*.

### Notes

It's easy to brainstorm flaws in this system but the major advantage is in memorability (*bird* vs *2473*) and the nudge towards PIN sanity. Since PINs are in general used as at most a second factor, the fact that *2473* maps back to a relatively large (108, in fact) pool of input mnenomics prevents simple reverse-engineering. Dictionary attacks are still highly plausible, though subset-mnemonics (e.g. "first four of *tomato*) are a mitigation. In general, though, most PIN systems are user-facing and thus easily enhanced with rate-limiting, logging, and auditing.

Note also that due to the quirks of T9 itself, PINs will only ever include the numbers 2-9. The significance of this is likely to be application dependent. (Though, off hand, it may facilitate default PINs which need only to contain 0 or 1 to be distinguished from user-supplied PINs.)


## `t9o`

**pending**

(Briefly, the tool follows the observation that T9's 2-9 numbers are easily mapped to octal 0-7 and uses a shift register.)

---

Copyright © 2019 Noah Santer `<ncwbbzp9@protonmail.com>`
