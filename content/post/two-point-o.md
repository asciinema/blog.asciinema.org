+++
date = "2018-02-18T21:00:00+01:00"
title = "2.0"

+++

I'm very happy to announce the release of asciinema 2.0!

It's been 3 years since 1.0 (time flies!), and during this period many ideas
have been brought to life through series of minor releases. This time the scope
and importance of the changes required major version bump.

Below we'll go through all the changes in detail, you can also read the
[CHANGELOG](https://github.com/asciinema/asciinema/blob/master/CHANGELOG.md#20-2018-02-10)
for a shorter version.

## asciicast v2 file format

asciinema 2.0 saves recordings in new [asciicast v2
format](https://github.com/asciinema/asciinema/blob/develop/doc/asciicast-v2.md).
It's based on [newline-delimited JSON spec](http://jsonlines.org/), and enables
incremental writing and reading of the recording.

It solves several problems which couldn't be easily fixed in the old format.
Mainly:

* when the recording session is interrupted (computer crash, accidental close of
  terminal window) you no longer lose the whole recording,
* minimal memory usage when recording and replaying long sessions - disk space
  is the only limit now,
* it's real-time streaming friendly (more on that below).

Due to file structure change (standard JSON => newline-delimited JSON) version 2
is not backwards compatible with version 1. Support for v2 recordings has
already been added in [asciinema web
player](https://github.com/asciinema/asciinema-player) (2.6.0) and [asciinema
server](https://github.com/asciinema/asciinema-server) (v20171105 tag in git
repository). These will handle both v1 and v2 playback nicely, older versions of
the recorder, player and server won't be able to play v2 recordings though.

[asciinema.org](https://asciinema.org) is now running the latest server and web player code and thus it fully supports this new format.

## Terminal-to-terminal streaming

Previous versions of asciinema supported in-terminal playback by piping in the
recording to its stdin:

    cat /path/to/asciicast.json | asciinema play -
    ssh user@host cat asciicast.json | asciinema play -

While useful in some scenarios, the whole recording had to be read into memory
before starting the playback (you can't easily parse JSON partially). New
format, being stream friendly, allows starting the playback immediately after
receiving the header line.

For example, you can now do terminal-to-terminal streaming via a [named Unix
pipe](https://en.wikipedia.org/wiki/Named_pipe#In_Unix):

    mkfifo /tmp/demo.pipe

    # viewing terminal
    asciinema play /tmp/demo.pipe

    # recording terminal
    asciinema rec /tmp/demo.pipe

Or stream terminal over the network with `netcat`:

    # viewing terminal (hostname: node123)
    asciinema play <(nc -l localhost 9999)

    # recording terminal
    asciinema rec >(nc node123 9999)

With new `--raw` recording mode (more on that below) you don't even need
asciinema installed on the viewing machine:

    # viewing terminal (hostname: node123)
    nc -l localhost 9999

    # recording terminal
    asciinema rec --raw >(nc node123 9999)

## Appending to existing recording

You can now append new session to an existing asciicast file.
This can be useful when you want to take a break when recording.

Start recording:

    asciinema rec demo.cast

When you need a break, press `<ctrl+d>` to finish recording. Then when you're ready to continue run:

    asciinema rec --append demo.cast

You can do this as many times as you want.

## Raw recording mode

You can now save raw stdout output, without timing information or other
metadata, to a file:   

    asciinema rec --raw output.txt

The output file produced in this case is not in asciicast format, and is exactly like the one produced by
[script](http://man7.org/linux/man-pages/man1/script.1.html) command (without timing file).

You can then use `cat` to print the result of the whole session:

    cat output.txt

## Stdin (keystroke) recording

Stdin recording allows for capturing of all characters typed in by the user in
the currently recorded shell:

    asciinema rec --stdin demo.cast

This may be used to display pressed keys during playback in
[asciinema-player](https://github.com/asciinema/asciinema-player) (not
implemented yet!). Because it's basically a key-logging (scoped to a single
shell instance), it's disabled by default, and has to be explicitly enabled via
`--stdin` option.

## Pausing playback

When replaying the asciicast in terminal with `asciinema play demo.cast`, you
can now press `space` to pause/resume. When paused, you can use `.` (dot key)
to step through the recording, a frame at a time, which can be very useful
during presentations! And, as before, `ctrl+c` will exit.

## New `cat` command

While `asciinema play <filename>` replays the recorded session using timing
information saved in the asciicast, `asciinema cat <filename>` dumps the full
output (including all escape sequences) of the recording to a terminal
immediately.

When you have existing recording, this command:

    asciinema cat existing.cast >output.txt

produces the same result as recording raw output with:

    asciinema rec --raw output.txt

## Summary

I'm especially happy about the first class support for real-time, incremental
recording. It's not only important for the features introduced with this
release, but it nicely prepares the ground for other live streaming options
(directly to web player, or indirectly to web player via asciinema-server). This
will most likely be an area where the most focus will go in the future.

Some of the native packages have already been updated (thanks to [awesome
package maintainers](https://github.com/asciinema/asciinema/issues/116)!), the
rest will hopefully follow soon. See [installation
docs](https://asciinema.org/docs/installation) for detailed instructions for you
system.

Enjoy better terminal recording and sharing!
