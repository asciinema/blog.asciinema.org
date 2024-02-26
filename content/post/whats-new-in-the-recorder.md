+++
date = "2023-09-01T08:00:00+01:00"
title = "What's new in asciinema - part II: the recorder"

+++

This is part 2 in the "what's new in asciinema" series. In the [first
part](/post/whats-new-in-the-player/) I looked at the player, in this one I'll
focus on [the recorder](https://docs.asciinema.org/manual/cli/) (aka CLI).

Fun fact: people use asciinema to record the terminal on Android. I would never
have thought of that but apparently there are folks who do that. Anyway,
recorder v2.0.2 (that's not really recent...) improved Android support, so if
you're a masochist who uses a terminal on a mobile device then you're covered ;)

<!--more-->

First feature I'd like to highlight is ability to "mute" the recording session,
i.e.  temporarily disable capture of terminal output, which was implemented in
version 2.1 of the recorder. This is handy when you realize mid-session that you
need to paste a secret and you don't want it to be recorded. Hit `C-\` (ctrl +
backslash) to mute, do the secret work, then unmute by using the same hotkey.
The hotkey can be changed with `rec.pause_key` option in [recorder's config
file](https://docs.asciinema.org/manual/cli/configuration/).

Out of necessity, the recorder received desktop notification integration in the
same release. See, asciinema recorder can't really print anything to the
terminal during a recording session (technically it can, but we avoid it)
because this could mess up the output/expectations of a program currently
running in the foreground, e.g. a shell, vim etc. So in order to inform the user
that terminal capture has been suspended, which I believe is essential here, I
implemented desktop notifications which work out of the box on Linux and macOS.
You can use a custom notification command (`notifications.command` in config
file) if you like, e.g.  to display the notification in tmux's status bar or
with some OSD tool.

In v2.2, the recorder got new options to override the terminal size that's
presented to the recorded process (e.g. your shell). Say your terminal has size
100x50 (cols x rows) and you want the recording to happen as if your terminal
had size 80x24.  You can do this:

```bash
asciinema rec --cols 80 --rows 24 rec demo.cast
```

This forces the size of 80x24 on the PTY (pseudo-terminal) under which your
shell operates while being recorded, resulting in the shell (or any program you
launched in it, e.g. vim) drawing their UI thinking it's 80x24 while your
terminal window is still 100x50. It's neat and comes in handy when you use
tiling WMs, because those tend to fill the screen to the brim, which is good for
productivity but less so for recording a demo that's meant to look good.

Also in v2.2, there have been a bunch of changes related to how asciinema
handles input and output. Specifically: where the input sent to the recorded
shell comes from, where the output of the shell goes to, and finally, where
diagnostic messages like "asciinema: recording asciicast to ..." go to. Those
improvements don't change much for the common `asciinema rec demo.cast` use
case, however they open interesting possibilities of composing the recorder with
other tools (and itself).

I'll illustrate with few examples.

```bash
asciinema rec --stdin demo.cast
asciinema play --stream=i demo.cast | asciinema rec new.cast
```

Let's break it down. First, we record the terminal, including the input
(`--stdin` option), to demo.cast file. Then, we replay only the input data from
it (`--stream=i`, added in v2.3), piping it to the recorder. In other words,
_key presses from the first recording are driving the new recording session_.
This lets you automatically re-record your demo e.g. with newer software
versions without manually typing the same commands again. How cool is that!

On a related note, check out [autocast](https://github.com/k9withabone/autocast)
by [Paul Nettleton](https://github.com/k9withabone) which lets you automate
creation of asciicast files in very comprehensive way.

Another nifty thing enabled by changes in v2.2 is the ability to pipe the
recorded asciicast to another process. Let's do some live streaming to a browser
via WebSockets:

```bash
asciinema rec - | websocat -q ws-l:127.0.0.1:9002 -
```

Here, we pass `-` as the output filename, which, by convention writes the output
to stdout. It then gets piped into [websocat](https://github.com/vi/websocat)
which starts a WebSocket server on port 9002, forwarding asciicast data it reads
from its own stdin to a WebSocket client.

It happens so that the player supports playback from WebSocket sources, which
we'll utilize to connect to websocat server started above:

```javascript
AsciinemaPlayer.create('ws://127.0.0.1:9002', document.getElementById('demo'));
```

The result is a real-time stream of a terminal session in the browser. It's not
a proper streaming solution by any means, far from it, but rather a
demonstration of composability of asciinema CLI.

In fact, we can combine the two previous examples into the ultimate composition:

```bash
asciinema play --stream=i demo.cast | asciinema rec - | websocat -q ws-l:127.0.0.1:9002 -
```

A live stream is driven by key presses from an existing recording! 🤯

This concludes recorder-related improvements. I hope you enjoyed it. In the
[next post](/post/whats-new-in-the-server/), we'll take a look at what's new in
[the server](https://docs.asciinema.org/manual/server/) and maybe a few other
things.

Until my next update, happy recording!
