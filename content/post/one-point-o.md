+++
date = "2015-03-13T11:47:08+01:00"
title = "1.0"

+++

I'm very happy to announce the release of asciinema 1.0, which brings many
long-awaited features and settles the ground for even more awesome features and
improvements coming in the future.

See
[CHANGELOG](https://github.com/asciinema/asciinema/blob/master/CHANGELOG.md)
for a detailed list of changes, continue reading for highlights of this
important release.

## Idle time optimization

Did you ever wish you had more powerful machine because this software
compilation you're recording takes long time? Or maybe you wanted to pause the
recording process, plan your next steps, and then resume recording? If you said
"yes!" to any of the above then you may like asciinema's new option.

`asciinema rec` command learned new option: `--max-wait`. It allows limiting
idle time, by replacing long pauses (terminal inactivity) with shorter ones.

You use it like this:

    asciinema rec --max-wait=2

This starts recording session in which all pauses longer than 2 seconds are
replaced with exactly 2 second ones.

An asciicast is worth a thousand words, so let's compare recording
with and without `--max-wait`. First, let's look at the result of
recording with plain `asciinema rec`:

<script type="text/javascript" src="https://asciinema.org/a/17645.js" id="asciicast-17645" async></script>

Now, let's look at the result of recording the same thing, this time with
`asciinema rec --max-wait=2`:

<script type="text/javascript" src="https://asciinema.org/a/17646.js" id="asciicast-17646" async></script>

Using this new option will make you look like you always know what to do next,
you're confident, and last but not least - you own a super computer that can
compile the biggest project in a matter of seconds. How cool is that?

## Local workflow

Another improvement to `asciinema rec` is its ability to save the recording to
a local file.

    asciinema rec demo.json

This saves the session to `demo.json` file. Now, you can replay it directly in
your terminal:

    asciinema play demo.json

Finally, if you're happy about it and you want to share it on asciinema.org
just run:

    asciinema upload demo.json

Let's see it in action:

<script type="text/javascript" src="https://asciinema.org/a/17642.js" id="asciicast-17642" async></script>

If you don't need to keep your recording local and just want to record and
upload in one step, you can still `asciinema rec` without a filename.

## New, simple asciicast format

Due to the fact that previous versions of asciinema recorder didn't allow
saving recordings locally, there was no stable and documented "asciicast
format".

This changes with 1.0. The file produced with `asciinema rec <filename>` is a
simple JSON file with a strict set of attributes. The format is versioned to
allow future extensions while preserving backwards compatibility. See
[asciicast file format version
1](https://github.com/asciinema/asciinema/blob/master/doc/asciicast-v1.md).

If you know how to deal with [ansi escape
sequences](https://en.wikipedia.org/wiki/ANSI_escape_code) you can manually
edit your recordings with a text editor, or build a tool that can post-process
them.

## Configuration file

There are several new options that can be set in `~/.asciinema/config` file.
See
[README](https://github.com/asciinema/asciinema/blob/master/README.md#configuration-file)
for a description of all of them.

Here's an example of setting `--max-wait` permanently, so you don't need to
pass it manually on each invocation of `asciinema rec`:

    [record]
    maxwait = 2

## Installing

All available installation methods can be found  on [installation
page](https://asciinema.org/docs/installation).

Note: not all native packages may be updated yet. If you want to make sure
you're getting the latest version of asciinema download a binary for you
platform [here](https://github.com/asciinema/asciinema/releases/tag/v1.0.0).


## The future

The changes introduced in this release, in addition to being valuable by
themselves, enable even more awesomeness in the future. For example, the
upcoming ability to self host (yes!) your recordings (without depending on
asciinema.org) wouldn't be possible without having a way to record to a file
with a well defined format.

I hope you'll enjoy the future. Meanwhile, enjoy asciinema 1.0!
