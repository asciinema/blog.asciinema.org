+++
date = "2021-11-22T23:00:00+01:00"
title = "4x smaller, 50x faster"

+++

It's been a while since asciinema-player 2.6 was released and a lot has changed
since. Version 3.0 is around the corner with so much good stuff, that even though
it's not released yet, I couldn't wait any longer to share.

Long story short: asciinema-player has been reimplemented from scratch in
JavaScript and Rust, resulting in 50x faster virtual terminal interpreter, while
at the same time, reducing the size of the JS bundle 4x.

<!--more-->

You may wonder what prompted the move from the previous ClojureScript
implementation. As much as I love Clojure/ClojureScript there were several major
and minor problems I couldn't solve, mostly around these 3 areas:

- speed - I wanted the player to be ultra-smooth, even for the most heavy
animated recordings. Due to ClojureScript's immutable data structures, there's a
lot of objects created and garbage collected all the time, and for the high
frame-rate, heavy animations this puts a lot of pressure on CPU and memory. The
new implementation of the virtual terminal interpreter in Rust (compiled to
WASM) does it 50x faster. Additional speed improvement comes from porting the
views from React.js to [SolidJS](https://www.solidjs.com), one of the fastest UI
libraries out there.

- size - the output bundle from ClojureScript compiler is rather big.  It's fine
when you build your own app in ClojureScript, however when you provide a library to
use by other people on their websites, it's quite bad. 2.6 is 570kb (minified) -
that's over half a megabyte. That bundle contains whole ClojureScript standard
library, several popular and useful libraries like reagent, core.async, and
finally React.js (via reagent). The new 3.0 is pure JS with pretty much just
SolidJS as the only dependency (which is tiny itself). This makes the new player
much smaller, ~140kb (minified), even though it includes embeded WASM bytecode
(which makes the bulk of the bundle size).

- integration with JS ecosystem - ClojureScript is not that easy to integrate
with the JS ecosystem. I know, there's been a lot of improvements done in this
space over the years, and I'm sure someone will immediately point me to relevant
docs, but it's still the extra mile you need to go when compared to regular JS
codebase, and some things didn't have any support last time I checked (like
embedding WASM in the bundle). Things might have changed here, but first two
arguments above still hold, so it was worth it. And as a result, you can now use
the player in your own app by importing the ES module provided by
[asciinema-player npm
package](https://www.npmjs.com/package/asciinema-player/v/3.0.0-beta.4).

Btw, special shout out to Ryan Carniato, the author of SolidJS, for focusing on
speed and simplicity, while not compromising on usability. Thanks Ryan!

Now, on top of all the above, I had fun building [terminal control sequence
interpreter in Rust](https://github.com/asciinema/vt-rs), using excellent
resource for that - [Paul Williams' parser for ANSI-compatible video
terminals](https://www.vt100.net/emu/dec_ansi_parser). Special shout out to Paul
Williams!

But back to speed. It used to be good enough, which is no longer good enough for
me. The old player used to be sufficiently fast for probably 90% of the
recordings people host on [asciinema.org](https://asciinema.org/explore). It
exercised many types of optimizations, like memoization (trading memory for CPU
time) and
[run-ahead](http://ku1ik.com/2017/04/21/lazy-seq-and-request-idle-callback.html)
(which used a lot of memory by precomputing terminal contents for each future
frame).

At first I planned to implement the terminal emulation part in Rust without any
optimizations, just write idiomatic Rust code, then revisit the tricks from the
old implementation. The initial benchmarks blew my mind though, showing that
spending additional time on optimizing the emulation part is absolutely
unnecessary.

The numbers show how many megabytes of text the terminal emulator can process in
each player version (tested on Chrome 88):

| recording                      | v2.6 (MB/s)        | v3.0 (MB/s)       | ratio |
|--------------------------------|--------------------|-------------------|-------|
| https://asciinema.org/a/20055  | 0.61               | 35.41             | 58x   |
| https://asciinema.org/a/153907 | 0.33               | 24.27             | 73x   |
| https://asciinema.org/a/44648  | 0.51               | 26.81             | 52x   |
| https://asciinema.org/a/117813 | 0.82               | 37.73             | 46x   |
| https://asciinema.org/a/325730 | 0.58               | 26.13             | 45x   |

50 times faster on average!

Note that the above benchmark represents the speed of text stream parsing
(including control sequences), as well as updating emulator's internal, _virtual_
screen buffer. This has been the bottleneck in the previous implementation of
the player. The benchmark doesn't measure rendering of the buffer to the actual
screen (DOM), therefore the rendering speed improvements coming from
React.js->SolidJS transition are not included here. However, SolidJS has been
benchmarked against React.js and other libs many times already, so I didn't
bother proving it's faster.

I still thought I may need to implement some form of terminal state
snapshot/restore to support the "seeking" feature. This feature requires feeding
the terminal emulator with the whole text stream between the current position
and the desired position, or in the worst case when you're seeking back, feeding
the emulator with the whole text from the very beginning of the recording up to
the desired position. Optimizing this could be done, for example, by keeping
snapshot of the terminal emulator state at multiple time points, sort of like
having key-frames every couple of seconds. In ClojureScript implementation this
came for free, thanks to the immutable data structures. In the new JS+Rust
implementation this would have required extra work, but it turned out, that's not
needed either - clicking on the progress bar in the new player, to jump to the
desired time in the recording, results in instantaneous jump, even when it has to
feed the emulator with megabytes of data to parse and interpret.

<div id="demo" class="player"></div>
<script>
  createPlayer('https://asciinema.org/a/20055.cast', document.getElementById('demo'), {
    speed: 3,
    poster: 'npt:9.5'
  });
</script>

Other than the speed and size improvements, the new version of the player brings
more nice things, like automatic scaling of the player to fill its container (as
seen above), as well as WebSocket and custom "drivers". More on these in the
upcoming posts.
