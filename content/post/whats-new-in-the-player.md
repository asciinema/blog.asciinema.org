+++
date = "2023-08-31T10:00:00+01:00"
title = "What's new in asciinema - part I: the player"

+++

There's been a steady stream of asciinema releases over the last 12 months and I
thought it would be nice to bring notable additions and improvements to the
light. This is the first post in the "what's new in asciinema" series, in which
I'll focus primarily on [the player](https://docs.asciinema.org/manual/player/),
highlighting changes I find most interesting. I will cover other parts of the
asciinema stack in future posts.

<!--more-->

First, a complete rewrite of the player resulted in [4x smaller, 50x
faster](/post/smaller-faster/) version 3.0. This enabled a lot of possibilities
and vastly improved integration of self-hosted player on websites.

Player v3.1 brought about improved terminal emulation, thanks to gradually
evolving [avt - asciinema virtual terminal](https://github.com/asciinema/avt).
We also got rendering of [faint graphic rendition - SGR
2](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters),
as well as the inclusion of [Nord theme](https://www.nordtheme.com/) in the
bundled CSS file.

Control bar display behaviour was improved in v3.2. The bar was moved below the
last terminal line. In previous versions it already automatically disappeared
when player detected lack of user interaction, however it still obscured the
last terminal line during such interaction. Later, in v3.4, new
[controls](https://docs.asciinema.org/manual/player/options/#controls) option
was added which can be used to force control bar to be always visible (`true`)
or always hidden (`false`). You can see the "always-on" control bar in the
markers demo later in this post.

This same release introduced the concept of [recording
parsers](https://docs.asciinema.org/manual/player/parsers/), which allows
playback of terminal sessions in formats other than player's native asciicast
format. Later, player v3.4 bundled parsers for
[ttyrec](https://nethackwiki.com/wiki/Ttyrec) and typescript files (produced by
[script command](https://www.man7.org/linux/man-pages/man1/script.1.html)). See
my [Blast from the past](/post/blast-from-the-past/) post for Star Wars
asciimation parser example.

Also in v3.2 player got ability to step through a (paused) recording one frame
at a time by pressing `.` (dot) key. This adds to a list of other useful key
bindings like `space` (toggle play/pause), `f` (toggle fullscreen), `]` (jump to
next marker, see below), and [few
others](https://docs.asciinema.org/manual/player/shortcuts/). Feel free to test
these in the player below.

Then, with v3.3, the player became more friendly for Reveal.js slide embeds.
However, probably the highlight of the release is support for [input
events](https://docs.asciinema.org/manual/asciicast/v2/#i-input-data-read-from-a-terminal)
embedded in asciicast files when recording with input capture enabled
(`asciinema rec --stdin demo.cast`).

For example, "the 't' key was pressed at 5 seconds" is saved in asciicast as the
following event line:

```json
[5.0, "i", "t"]
```

If you're self-hosting the player you can subscribe to input events with
`player.addEventListener`
([doc](https://docs.asciinema.org/manual/player/api/#input-event)). Say, you
want to play Cherry MX Brown (eeewww!) sound for each key press.

```javascript
const player = AsciinemaPlayer.create({
  url: '/typing.cast',
  inputOffset: -0.125
}, document.getElementById('demo'));

player.addEventListener('input', e => {
  playSound('/Cherry_MX_Brown.wav');
});
```

Below is the result (make sure your audio is not on mute):

<div id="demo-evol-input" class="player"></div>

It sounds mechanical and not very natural because I used a single sample, so
there's no variation whatsoever. For more natural effect use multiple samples,
and have a special one for space key which often sounds different than the rest,
due to its size and the way it's mounted. The event argument, passed to the
callback, has `data` property, which corresponds to asciicast input event's 3rd
field ("t" in the example earlier). This can be used to check which key was
pressed and what sample to play.

I used new `inputOffset` option with a value of `-0.125` (sec) to shift input
events in time. I did it because the key press sample I use has a bit of a slow
attack, so by firing the sound slightly earlier I got the audio in better sync
with the display.

Next, player v3.4 and
[markers](https://docs.asciinema.org/manual/player/markers/). This feature was
often requested, and one which was added to the whole stack (player, server,
recorder). Let's take a look at that next.

In the player below notice the dots on the timeline. Those are markers which,
when hovered, show time and text labels. Markers mark chapters or other
interesting points in the timeline of a recording.

<div id="demo-evol-markers" class="player"></div>

As expected, clicking on a marker fast-forwards/rewinds the recording to
selected position.  You can also navigate between markers by pressing the `[`
and `]` keys which respectively jump to previous and next marker. You can also
[seek](https://docs.asciinema.org/manual/player/api/#seeklocation) to a marker
programatically.

There are several ways to add markers to a recording. If you keep your
recordings on [asciinema.org](https://asciinema.org) or you [self-host the
server](https://docs.asciinema.org/manual/server/self-hosting/) you can add
markers on recording's settings page. If you use the player on your own site you
can pass markers via new
[markers](https://docs.asciinema.org/manual/player/options/#markers) option like
this:

```javascript
AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'), {
  markers: [
    [5.0,   "Installation"],  // time in seconds + label
    [25.0,  "Configuration"],
    [66.6,  "Usage"],
    [176.5, "Tips & Tricks"]
  ]
});
```

Finally, you can embed markers directly in asciicast files. Marker events look
similar to input events we saw earlier, but the event code is `m` here:

```json
[25.0, "m", "Configuration"]
```

Those can be added to a recording either during the recording session by
pressing a hotkey (see `rec.add_marker_key` [config
option](https://docs.asciinema.org/manual/cli/configuration/)) or after
recording by adding lines like the one above to the asciicast file.

There's also new
[pauseOnMarkers](https://docs.asciinema.org/manual/player/options/#pauseonmarkers)
option which tells the player to automatically pause the playback when reaching
next marker. This is super useful for "live" demos as it lets you discuss
terminal output at precise points.

This concludes player-related improvements. In the [next
post](/post/whats-new-in-the-recorder/), we'll take a look at what's new in [the
recorder](https://docs.asciinema.org/manual/cli/), aka CLI.

Until my next update, happy recording!

<script>
const opts = {
  preload: true,
  theme: 'dracula'
};

const player1 = await createPlayer({
  url: '/casts/typing.cast',
  inputOffset: -0.125
}, document.getElementById('demo-evol-input'), {
  ...opts,
  rows: 15,
  poster: 'npt:8.4'
});

const url = '/Cherry_MX_Brown.wav';
const context = new AudioContext();
let clickbuffer;

fetch(url)
  .then(response => response.arrayBuffer())
  .then(data => context.decodeAudioData(data))
  .then(buf => { clickBuffer = buf });

function playKeypressSound(e) {
  const source = context.createBufferSource();  // create a sound source
  source.buffer = clickBuffer;                  // tell the source which sound to play
  source.connect(context.destination);          // connect the source to the context's destination (the speakers)
  const gainNode = context.createGain();        // create a gain node
  source.connect(gainNode);                     // connect the source to the gain node
  gainNode.connect(context.destination);        // connect the gain node to the destination
  gainNode.gain.value = 1;                      // set the volume
  source.start(0);
}

player1.addEventListener('input', playKeypressSound);

createPlayer('/casts/misc.cast', document.getElementById('demo-evol-markers'), {
    ...opts,
    controls: true,
    poster: 'npt:27.4',
    markers: [
      [2.0, 'asciiquarium'],
      [17.0, 'neofetch'],
      [24.0, 'Building agg'],
      [54.0, 'agg\'s help message'],
    ]
  }
);
</script>
