+++
date = "2015-03-31T17:05:08+01:00"
title = "New ways of asciicast embedding"

+++

Support for embedding asciicasts just got way more awesome. See [embedding
docs](https://asciinema.org/docs/embedding) for details, read on for examples.

## Embedding on your site

In addition to the existing support for embedding full player widget on your
page, you can now use image link to display a screenshot linking to your
recording on asciinema.org. This is useful in places where script tags are not
allowed, for example in Github README files.

You can get the embed snippets for a specific asciicast by clicking on "Embed"
link on asciicast page.

Here's an example of how the image link looks like:

<a href="https://asciinema.org/a/22124" target="_blank"><img src="https://asciinema.org/a/335480.svg" /></a>

## Embedding on Slack, Twitter and Facebook

asciinema.org supports [oEmbed](http://oembed.com/), [Open
Graph](http://ogp.me/) and [Twitter
Card](https://dev.twitter.com/cards/overview) protocols now. When you share an
asciicast on Twitter, Slack, Facebook, Google+ or any other site which supports
one of these APIs, the asciicast is presented in a rich form (usually with a
title, author, description and a thumbnail image), linking to your recording on
asciinema.org.

Here's how it looks on Slack:

<img src="/img/embed-slack.png" width="504" />

And here's my tweet including a link to the same asciicast:

<img src="/img/embed-twitter.png" width="636" />
