+++
date = "2023-10-12T10:00:00+01:00"
title = "What's new in asciinema - part III: the server"

+++

This is part 3 in the "what's new in asciinema" series. In the [first
part](/post/whats-new-in-the-player/) we looked at the player, in the [second
part](/post/whats-new-in-the-recorder/) we covered the recorder, and in this one
we'll focus on [the server](https://github.com/asciinema/asciinema-server).

Let's begin with OPS stuff.

[asciinema.org](https://asciinema.org) uses email-based login flow, where you
get short lived login link (some call it "magic link"). Over last 10 years that
email was delivered via several email providers. From the top of my head,
roughly in order: Mailgun, Gmail, Sendgrid, Fastmail. I won't go into details of
why I've been switching from X to Y, as the reason was different in each case,
but overall there was always something (and when it wasn't a tech issue then it
was a price issue). The last switch happened a few months ago to AWS SES. It's
been reliable (so far) and ridiculously cheap. asciinema server uses
[Bamboo](https://github.com/beam-community/bamboo) library for email delivery,
and thanks to Bamboo's pluggable adapters it was trivial to switch. If you want
to use SES for email delivery with your own instance of the server then follow
the [instructions
here](https://github.com/asciinema/asciinema-server/wiki/SMTP-configuration#aws-ses).


<!--more-->

Next, the recent [integration of
libcluster](https://github.com/asciinema/asciinema-server/commit/b5938fc74645d5a292c2abdb81e8cc11d7091146)
will ensure live features of [Phoenix
framework](https://www.phoenixframework.org/), such as LiveView and PubSub, work
seamlessly in multi-node setups (like the one on asciinema.org). This will come
in handy for live streaming feature which should come soon (more on that in a
future post).

Concluding the admin/OPS side, I'll mention that I moved the official docker
image of the asciinema server from `docker.io/asciinema/asciinema-server` to
`ghcr.io/asciinema/asciinema-server`. Docker Inc.'s recent [hostility towards
open-source](https://news.ycombinator.com/item?id=35166317) (without which it
wouldn't have existed in the first place) didn't feel right. While they later
[apologized for "doing a terrible
job"](https://www.theregister.com/2023/03/17/docker_free_teams_plan/) it was too
little too late. Damage was done, I'm not going back there. They're gonna pull
off something similar in the future.  GitHub's [ghcr.io](https://ghcr.io) is
owned by another corporation, sure, but they seem to understand the value of
open-source communities better than current Docker Inc. management, therefore
until they prove me wrong I'm willing to keep the container images there. It's
not that hard to migrate away if they do.

Shifting under the hood of the server, there's been a lot of maintenance and
code refactoring. In addition to preparation for more real-time features
mentioned earlier, Elixir, Erlang and Phoenix, upon which the server is built,
were updated to newer versions (Elixir 1.14, Erlang/OTP 25.2, Phoenix 1.7). I
started converting view templates to new `.heex` format, which elegantly solves
view component reusability and composability, while ensuring HTML syntax
validity at compile-time. Super neat stuff, and I'm excited about this, even
though the conversion from `.eex` to `.heex` requires extra work.

Furthermore, the server got basic [WebFinger](https://webfinger.net/) endpoint
([my asciinema.org user in WebFinger lookup
service](https://webfinger.net/lookup/?resource=ku1ik%40asciinema.org)). Even
though it's not very useful right now, it will become instrumental in future
developments ;)

SVG previews, which are available by appending `.svg` to a recording URL, got
support for "true color" (24-bit SGR variant):
https://asciinema.org/a/335480.svg

Finally, on the UI side, you might have noticed addition of [Nord
theme](https://www.nordtheme.com/) in theme selector (both in [user
settings](https://asciinema.org/user/edit) and individual recording settings),
as well as new font selector, which allows using one of [Nerd
Fonts](https://www.nerdfonts.com/) variants with your recordings (useful if you
have fancy shell prompt with symbols/icons).  Additionally, recording metadata,
i.e.  icons for terminal environment (OS, term type, shell) and views count,
received a bit of polish.  Recording index pages were updated to use an
appropriate number of thumbnail columns on various screen sizes.

Lastly, [markers feature of the
player](https://github.com/asciinema/asciinema-player#markers-1) has been
exposed on recording settings page - you can configure a list of markers by
simply listing their times and labels like this:

```
5.0 - Intro
11.3 - Installation
32.0 - Configuration
66.5 - Tips & Tricks
```

This concludes the server-related improvements, and the "what's new in
asciinema" series. I hope you enjoyed it. Don't hesitate to reach out with
feedback, I'm all ears (not as much as [this little
guy](https://mastodon.social/@doublehelix/111218469773975528) though).

Happy recording!
