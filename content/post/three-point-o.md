+++
date = "2025-09-15T12:00:00+01:00"
title = "3.0"

+++

I'm happy to announce the release of asciinema CLI 3.0!

This is a complete rewrite of asciinema in Rust, upgrading the recording file
format, introducing terminal live streaming, and bringing numerous improvements
across the board.

In this post, I'll go over the highlights of the release. For a deeper overview
of new features and improvements, see the [release
notes](https://github.com/asciinema/asciinema/releases/tag/v3.0.0) and the
detailed
[changelog](https://github.com/asciinema/asciinema/blob/develop/CHANGELOG.md).

First, let's get the Rust rewrite topic out of the way. I did it because I felt
like it. But seriously, I felt like it because I prefer working with Rust 100x
more than with Python these days. And this type of code, with syscalls and
concurrency, is way easier to deal with in Rust than in Python. That's my
experience, YMMV. Anyway, in addition to making me enjoy working with this
component of asciinema again, the rewrite resulted in faster startup, easier
installation (a static binary), and made many new features possible by
integrating [asciinema virtual terminal](https://github.com/asciinema/avt)
(also Rust) into the CLI.

Let's look at what's cool and new now.

## asciicast v3 file format

The new [asciicast v3](https://docs.asciinema.org/manual/asciicast/v3/) file
format is an evolution of the good old asciicast v2. It addresses several
shortcomings of the previous format that were discovered over the years.

The major change in the new format is the use of intervals (deltas) for timing
session events. v2 used absolute timestamps (measured since session start),
which had its own pros and cons. One often-brought-up issue was the difficulty
of editing the recordings - timestamps of all following events had to be
adjusted when adding/removing/updating events.

Other than timing, the header has been restructured, grouping related things
together, e.g. all terminal-related metadata is now under `term`. There's also
support for the new `"x"` (exit) event type, for storing the session exit
status. Finally, line comments are allowed by using the `#` character as the
first character on a line.

Here's an example of a short recording in asciicast v3 format:

```json
{"version": 3, "term": {"cols": 80, "rows": 24, "type": "xterm-256color"}, "timestamp": 1504467315, "title": "Demo", "env": {"SHELL": "/bin/zsh"}}
# event stream follows the header
[0.248848, "o", "Hey Dougal...\n"]
[0.248848, "o", "Yes Ted?\n"]
[1.001376, "o", "Is there anything on your mind?\n"]
[3.500000, "m", ""]
[0.143733, "o", "No."]
# terminal window resized to 90 cols and 30 rows
[2.050000, "r", "90x30"]
[1.541828, "o", "Bye!"]
[0.8870, "x", "0"]
```

The new format is already supported by [asciinema
server](https://docs.asciinema.org/manual/server/) and [asciinema
player](https://docs.asciinema.org/manual/player/).

## Live terminal streaming

The new CLI allows for live streaming of terminal sessions, and provides two
modes for doing so.

Local mode uses built-in HTTP server, allowing people to view the stream on
trusted networks (e.g. a LAN). In this mode no data is sent anywhere, except to
the viewers' browsers, which may require opening a firewall port. The CLI
bundles the latest version of asciinema player, and uses it to connect to the
stream from the page served by the built-in server.

```
$ asciinema stream --local
::: asciinema session started
::: Live streaming at http://127.0.0.1:37881
::: Press <ctrl+d> or type 'exit' to end
$ _
```

Remote mode publishes the stream through an asciinema server (either
asciinema.org or a self-hosted one), which acts as a relay, delivering the
stream to the viewers at a shareable URL.

```
$ asciinema stream --remote
::: asciinema session started
::: Live streaming at https://asciinema.org/s/TQGS82DwiBS1bYAY
::: Press <ctrl+d> or type 'exit' to end
$ _
```

The two modes can be used together as well.

Here's a live stream of `btop` running on one of the asciinema.org servers:

<div id="demo-btop" class="player"></div>

You can also watch it directly on asciinema.org at
[asciinema.org/s/olesiD03BIFH6Yz1](https://asciinema.org/s/olesiD03BIFH6Yz1).

Read more about the streaming architecture and supported protocols
[here](https://docs.asciinema.org/manual/server/streaming/).

asciinema player (seen above) supports all the described protocols. To make the
viewing experience smooth and glitch-free, it implements an adaptive buffering
mechanism. It measures network latency in real-time and adjusts the buffer size
constantly, aiming for a good balance between low latency and buffer-underrun
protection.

asciinema server can now record every live stream and turn it into a regular
recording. At the moment, asciinema server running at asciinema.org has stream
recording disabled and a concurrent live stream limit of 1, but you can
self-host the server where recording is enabled and there's no concurrent
stream limit by default. The limits on asciinema.org may change. I'd like to
first see how the streaming feature affects resource usage (btw, shout-out to
[Brightbox](https://www.brightbox.com/), which provides cloud services for
asciinema.org).

## Local-first

In the early versions of asciinema, `asciinema rec` didn't support saving to a
file - the recording was saved to a tmp file, uploaded to asciinema.org, and
the tmp file was removed. Later on, the CLI got the ability to specify a
filename, which allowed you to save the result of a recording session to a file
in asciicast v1 format and decide whether you want to keep it local only or
publish.

Although optional, the filename argument had long been available. However,
many, many tutorials on the internet (probably including asciinema's own docs)
showed examples of recording and publishing in one go with `asciinema rec`.
That was fine - many people loved this short path from recording to sharing.

Over the years, I started seeing two problems with this. The first one is that
lots of people still think you must upload to asciinema.org, which is not true.
You can save locally and nothing leaves your machine. The second one is that
the optionality of the filename made it possible to unintentionally publish a
recording, and potentially leak sensitive data. And it's a completely valid
concern!

Because of that, on several occasions I've seen negative comments saying
"asciinema is shady" /m\\. It was never shady. It's just a historical thing. I
just kept the original behavior for backward compatibility. asciinema.org is
not a commercial product - it's _an_ instance of asciinema server, which is
meant to give users an easy way to share, and to give a taste of what you get
when you self-host the server. In fact, I encourage everyone to self-host it,
as the recordings uploaded to asciinema.org are a liability for me (while being
a good promotion of the project :)).

I hope this clears up any confusion and suspicion.

Anyway, many things have changed since the original behavior of `asciinema
rec` was implemented, including my approach to sharing my data with cloud
services. These days I self-host lots of services on a server at home, and I
try to avoid cloud services if I can (I'm pragmatic about it though).

The streaming feature was built from the ground up to support the local mode,
which came first, and the remote mode followed.

In asciinema CLI 2.4, released 2 years ago, I made the `upload` command show a
prompt where you have to explicitly make a decision on what to do with the
recording. It looked like this:

```
$ asciinema rec
asciinema: recording asciicast to /tmp/tmpo8_612f8-ascii.cast
asciinema: press <ctrl-d> or type "exit" when you're done
$ echo hello
hello
$ exit 
asciinema: recording finished
(s)ave locally, (u)pload to asciinema.org, (d)iscard
[s,u,d]? _
```

It was a stopgap and a way to prepare users for further changes that are coming
now.

In 3.0, the filename is always required, and the `rec` command no longer has
upload capability. To publish a recording to asciinema.org or a self-hosted
asciinema server, use the explicit `asciinema upload <filename>`.

## More self-hosting-friendly

A related improvement introduced in this release is the new server URL prompt.

When using a command that integrates with asciinema server (`upload`, `stream`,
`auth`) for the first time, a prompt is shown, pre-filled with
https://asciinema.org (for convenience). This lets you choose an asciinema
server instance explicitly and intentionally. The choice is saved for future
invocations.

It was always possible to [point the CLI to another asciinema
server](https://docs.asciinema.org/manual/cli/configuration/) with a config
file or environment variable, but this new prompt should come in handy
especially when running the CLI in a non-workstation/non-laptop yet interactive
environment, such as a fresh VM or a dev container.

This change should make it easier to use the CLI with your own asciinema
server, and at the same time it doubles as an additional guard preventing
unintended data leaks (to asciinema.org).

## Summary

I'm really excited about this release. It's been in the making for a while, but
it's out now, and I'm looking forward to seeing what new use-cases and
workflows people will discover with it.

It's going to take a moment until 3.0 shows up in package repositories for all
supported platforms/distros. Meanwhile, you can download prebuilt binaries for
GNU/Linux and macOS from the [GitHub
release](https://github.com/asciinema/asciinema/releases/tag/v3.0.0), or [build
it from source](https://github.com/asciinema/asciinema#building).

Thanks for reading to this point!

<script>
const opts = {
  theme: 'asciinema',
  logger: console,
  autoPlay: true
};

createPlayer(
  'wss://asciinema.org/ws/s/olesiD03BIFH6Yz1',
  document.getElementById('demo-btop'), {
  ...opts,
});
</script>
