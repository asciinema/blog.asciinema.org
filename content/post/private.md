+++
date = "2015-05-11T15:45:08+01:00"
title = "Private asciicasts"

+++

The core idea behind asciinema.org is to allow anyone to share the recording of
their terminal session by simply sharing a link to your asciicast page. Since
the inception of asciinema all recordings has been public. We wanted to
encourage you to share your knowledge, show off your tricks, and allow others
to learn from it.

<!--more-->

It appears though that the nature of the asciicasts is often semi-private. Many
of you would like to record something and share it with a selected group of
people only, your team-mates for example. There were [requests
for](https://github.com/asciinema/asciinema.org/issues/34) [private
asciicasts](https://github.com/asciinema/asciinema/issues/66). There were some
ideas to workaround the fact that everything on asciinema.org was public.
asciinema would be way more useful if it allowed you to decide if and with whom
you share the recordings, wouldn't it?

The good news is as of today all new recorded asciicasts are private by
default. They get unique, secret URLs (like Github's gists) which means you can
share them with selected people as easy as before. Whoever gets the secret link
can view the asciicast. Private asciicasts are not listed on the
[Browse](https://asciinema.org/browse) page or anywhere else on the site.

Public asciicasts are still a thing though, and you can publish any of your
recordings by clicking "Make public" in gear dropdown menu on an asciicast
page. If you'd rather have all your new recordings public by default you can
change the visibility policy on your asciinema.org account settings page.

It's possible that next version of asciinema recorder will have -p and -P
switches for asciinema rec and asciinema upload commands, which will force
private (-p) or public (-P) visibility for a single asciicast, overriding the
default account policy.

Enjoy!
