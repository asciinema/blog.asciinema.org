+++
date = "2016-01-06T17:45:00+01:00"
title = "Self-hosting"

+++

I'm very happy to announce version 2.0 of the asciinema web player. There are
several exciting aspects of this release so let's get straight to the point.

First, the new player directly supports
[asciicast v1 format](https://github.com/asciinema/asciinema/blob/master/doc/asciicast-v1.md).
In other words, there is no need to pre-process the recording upfront, before
passing it to the player. This is possible thanks to built-in terminal emulator
based on
[Paul Williams' parser for ANSI-compatible video terminals](http://vt100.net/emu/dec_ansi_parser).
It covers only the display part of the emulation, as this is what the player is
all about (input is handled by your terminal+shell at the time of recording
anyway). Handling of escape sequences is fully compatible with most modern
terminal emulators like xterm, Gnome Terminal, iTerm, mosh etc.

This is cool in itself, but the best part of it is that it enables self-hosting
of the recordings on your own website, without depending on
[asciinema.org](https://asciinema.org). If you're not comfortable keeping your
recordings on asciinema.org ("in the cloud" == "other people's computers"), or
you simply prefer to own and fully control your content, this release solves
this problem for you. Just place player's `.js` + `.css` files together with
`.json` file of your recording in your web assets directory, and insert short
`<script>` tag in your HTML. Take a look at
[README](https://github.com/asciinema/asciinema-player) for quick start.

It's also worth mentioning that this version of the player (including terminal
emulator part) has been implemented in ClojureScript. If you were sceptical
about performance of compile-to-javascript languages and/or performance of
immutable data structures then this will hopefully convince you that there's no
need to worry about it. ClojureScript compiler does a wonderful job of
converting high level Clojure code into highly optimized, fast JavaScript code.
If it's possible to build a performant player like this one in ClojureScript
then you can build anything in ClojureScript. Look at the
[source](https://github.com/asciinema/asciinema-player/tree/master/src/cljs/asciinema_player)
if you're curious how it looks like.

Check
[asciinema/asciinema-player](https://github.com/asciinema/asciinema-player) on
Github for API documentation and usage examples.

Enjoy!
