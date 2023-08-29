+++
date = "2023-06-19T20:00:00+01:00"
title = "Blast from the past"

+++

Did you know that the first prototype of what later became the asciinema player
replayed "typescript" files produced by [script
command](https://en.wikipedia.org/wiki/Script_(Unix))?

In fact, the whole asciinema project originated with the player, not with the
command line recorder. That was back in 2010. I was having fun with `script` and
`scriptreplay` commands, when I imagined being able to easily share typescript
files with fellow geeks, who could watch the recordings in their browsers. I
wrote a rough parser/interpreter for typescript format and got some characters
moving happily on a page with the help of a bunch `<div>` and `<span>` elements.

<!--more-->

Back then, `script` version found in most Linux distros was capable of saving
timing information to a second file with `-t` option (later deprecated,
superseded with newer `-T`). For playback, timing information is essential, so
all was great.  Except, I wanted to support macOS (or, then "OS X") as well as
*BSD systems. The version of the `script` command that was shipped with OS X
unfortunatelly didn't support saving timing information. I learned this by
causing many work interruptions to my colleague [MacKuba](https://mackuba.eu/),
who was working on OS X and was sitting in the same office room as me.

I figured out how `script` works, what is a PTY, TTY and whatnot, and eventually
found Python's [pty module](https://docs.python.org/3/library/pty.html) which
had a small code example at the bottom of the page, which showed how to write
your own (simplified) `script` in Python with nothing more than standard
library. I tested this on Linux and OS X - worked beautifully. So I decided to
drop `script` and create my own recorder with its own JSON-based recording
format -
[asciicast](https://github.com/asciinema/asciinema/blob/develop/doc/asciicast-v1.md).
The rest is history.

Fast-forward to 2023. `script` on all popular platforms, including macOS,
supports saving timing information (this happened somewhere between 2011 and now,
but not sure when precisely). JS has [fetch
API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) (since 2015),
which, combined with full adoption of
[ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer)
and
[TypedArrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)
allows fetching and parsing files in any format with relative ease.

Which brings us to recently released [asciinema player
3.4.0](https://github.com/asciinema/asciinema-player/releases/tag/v3.4.0), which
added [support for additional recording
formats](https://github.com/asciinema/asciinema-player#playing-other-recording-formats)
through
[parsers](https://github.com/asciinema/asciinema-player/blob/develop/src/parser/README.md).
In addition to asciicast
([v1](https://github.com/asciinema/asciinema/blob/develop/doc/asciicast-v1.md)
and
[v2](https://github.com/asciinema/asciinema/blob/develop/doc/asciicast-v2.md)),
which has been THE recording format of the player since the beginning, asciinema
player can now replay typescript recordings, [ttyrec
recordings](https://nethackwiki.com/wiki/Ttyrec) (produced by
[ttyrec](http://0xcc.net/ttyrec/), [termrec](http://angband.pl/termrec.html) or
[ipbt](https://www.chiark.greenend.org.uk/~sgtatham/ipbt/)), as well as any
other terminal recording format you write a custom parser for.

Here's how to use the player with typescript recordings:

```javascript
AsciinemaPlayer.create({
  url: ['/demo.timing', '/demo.data'],
  parser: 'typescript'
}, document.getElementById('demo'));
```

Note `url` above being an array of URLs pointing to typescript timing and data
files.

And here's how to use the player with ttyrec recordings:

```javascript
AsciinemaPlayer.create({
  url: '/demo.ttyrec',
  parser: 'ttyrec'
}, document.getElementById('demo'));
```

See [parsers documention](https://github.com/asciinema/asciinema-player/blob/develop/src/parser/README.md) for more details.

Note: typescript and ttyrec recordings can be used with [self-hosted asciinema
player](https://github.com/asciinema/asciinema-player). As of this writing
[asciinema.org](https://asciinema.org) supports asciicast files only.

One more thing...

I mentioned playing custom recording formats. Let's do one more blast from the past.

In 1997 Simon Jansen created initial version of his famous [Star Wars
Asciimation](https://www.asciimation.co.nz/). You may have seen it via `telnet
towel.blinkenlights.nl` (defunct as of 2023). Simon's asciimation file format is
a simple text format, where each animation frame is defined by 14 lines. First of
every 14 lines defines duration a frame should be displayed for (multiplied by a
speed constant, by default `67` ms), while lines 2-14 define frame content -
text to display.

Let's write asciinema player parser for it:

```javascript
const LINES_PER_FRAME = 14;
const FRAME_DELAY = 67;
const COLUMNS = 67;
const ROWS = LINES_PER_FRAME - 1;

async function parseAsciimation(response) {
  const text = await response.text();
  const lines = text.split('\n');
  const output = [];
  let time = 0;
  let prevFrameDuration = 0;

  output.push([0, '\x9b?25l']); // hide cursor

  for (let i = 0; i + LINES_PER_FRAME - 1 < lines.length; i += LINES_PER_FRAME) {
    time += prevFrameDuration;
    prevFrameDuration = parseInt(lines[i], 10) * FRAME_DELAY;
    const frame = lines.slice(i + 1, i + LINES_PER_FRAME).join('\r\n');
    let text = '\x1b[H'; // move cursor home
    text += '\x1b[J'; // clear screen
    text += frame; // print current frame's lines
    output.push([time / 1000, text]);
  }

  return { cols: COLUMNS, rows: ROWS, output };
}

AsciinemaPlayer.create(
  { url: '/starwars.txt', parser: parseAsciimation },
  document.getElementById('demo')
);
```

Here it is in action:

<div id="demo-starwars" class="player"></div>

<script>
const LINES_PER_FRAME = 14;
const FRAME_DELAY = 67;
const COLUMNS = 67;
const ROWS = LINES_PER_FRAME - 1;

async function parseAsciimation(response) {
  const text = await response.text();
  const lines = text.split('\n');
  const output = [];

  let time = 0;
  let prevFrameDuration = 0;

  output.push([0, '\x9b?25l']); // hide cursor

  for (let i = 0; i + LINES_PER_FRAME - 1 < lines.length; i += LINES_PER_FRAME) {
    time += prevFrameDuration;
    prevFrameDuration = parseInt(lines[i], 10) * FRAME_DELAY;
    const frame = lines.slice(i + 1, i + LINES_PER_FRAME).join('\r\n');
    let text = '\x1b[H'; // move cursor home
    text += '\x1b[J'; // clear screen
    text += frame; // print current frame's lines
    output.push([time / 1000, text]);
  }

  return { cols: COLUMNS, rows: ROWS, output };
}

AsciinemaPlayer.create(
  { url: '/starwars.txt', parser: parseAsciimation },
  document.getElementById('demo-starwars'),
  {
    cols: COLUMNS,
    rows: ROWS,
    poster: 'npt:9.5'
  }
);
</script>

Maybe Simon finishes it one day :)
