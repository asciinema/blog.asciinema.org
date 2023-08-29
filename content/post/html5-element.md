+++
date = "2016-10-02T13:19:00+01:00"
title = "<asciinema-player> HTML5 element"

+++

We have just released asciinema web player v2.3.0. Since v2.0.0 there were two
smaller releases bringing lots of improvements (see
the
[CHANGELOG](https://github.com/asciinema/asciinema-player/blob/master/CHANGELOG.md)),
but this one definitely deserves a post of its own.

This new version makes self-hosting of the player even simpler. Let's see an example.

<!--more-->

Before:

```html
<div id="player-container"></div>
<script>
  asciinema.player.js.CreatePlayer('player-container', '/demo.json');
</script>
```

Today:

```html
<asciinema-player src="/demo.json"></asciinema-player>
```

Awesome, right?

This is possible thanks
to [HTML5 Custom Elements](http://w3c.github.io/webcomponents/spec/custom/),
which allow web developers to define new types of HTML elements. New
`asciinema-player.js` includes definition of new `AsciinemaPlayer` element type
and its associated `<asciinema-player>` tag. The `.js` bundle also provides
Custom Element polyfill which makes the new element working in browsers which
don't support this feature yet.

The element supports several attributes known from `<video>` element like
`loop`, `autoplay`, `preload`, as well as asciinema-specific ones like `speed`,
`theme`, `font-size`.

See
[README](https://github.com/asciinema/asciinema-player/blob/master/README.md)
for a quick "getting started with self-hosting" guide and a description of all
supported attributes.

Enjoy!
