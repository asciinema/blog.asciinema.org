+++
date = "2016-07-13T21:30:00+01:00"
title = "1.3 aka \"And Now for Something Completely Different\""

+++

I'm very happy to announce the release of asciinema 1.3, which is kind of a
special release. It brings several bug fixes and improvements for end users, and
at the same time it makes life of asciinema developers (mostly me) and package
maintainers (many people!) way easier.

See
[CHANGELOG](https://github.com/asciinema/asciinema/blob/master/CHANGELOG.md#130-2016-07-13)
for a detailed list of changes, continue reading for motivation on transitioning
back to Python.

Wait, what? Back to Python? Yes, asciinema 1.3 brings back the original Python
implementation of asciinema. It's based on 0.9.8 codebase and adds all features
and bug fixes that have been implemented in asciinema's Go version between 0.9.8
and 1.2.0. We'll keep the Go implementation in
[golang](https://github.com/asciinema/asciinema/tree/golang) branch, it won't be
maintained though.

While Go definitely has its strengths (easy concurrency, runtime speed, startup
speed, stand-alone binary), this project didn't really benefit from any of these
(and suffered from Go's pain points). Here is a (not exhaustive) list of things
that contributed to the decision of dropping Go for Python:

* No need for concurrency or high speed here.
* Python is high level language while Go is lower level language (I think
  it's fair to say it's C 2.0). 95% of asciinema codebase is high level code and
  there's basically a single file containing system calls like
  select/signal/ioctl/fork.
* Build problems: pty/terminal related Go libs don't support as many
  [architectures](https://github.com/asciinema/asciinema/issues/134) and
  [operating systems](https://github.com/asciinema/asciinema/issues/144) while
  Python runs basically on every UNIX-like system.
* Go's lack of versioned packages and central repository makes packaging
  cumbersome. For example, some distro packaging rules don't like
  straight-from-github-master dependencies (understandable!) while at the same
  time they don't like vendored (bundled) dependencies (also understandable)
  ([Gentoo example](https://bugs.gentoo.org/show_bug.cgi?id=532918)).
* Batteries included: argparse, pty, locale, configparser, json, uuid, http. All
  of these excellent modules are used by asciinema and are part of Python's
  standard library. Python stdlib's quality and stability guarantees are order
  of magnitude higher than of unversioned Go libs from Github (I believe
  discrete releases ensure higher quality and more stability).
* The less external dependencies the easier the job for native package
  maintainers - as of this moment we have zero external dependencies!
* Casting int32 to int64 to... gets old fast.
* `if err != nil {` gets old even faster.

asciinema recorder codebase (and feature set) is relatively small (under 900
LOC currently) so it wasn't a big effort to port all newer features on top of
the old Python implementation.

Note, that the above list applies specifically to asciinema recorder. There are
great use cases for Go (like [IPFS](https://ipfs.io/)) and if I was to build
system-level software, protocol implementation or any kind of network daemon
(proxy for example) I'd definitely consider Go. Also, asciinema is a cli app
distributed to end users. If you're building in-house software that has to run
only on single platform then many of the above points may become non-issue for
you.

Anyway, it feels good to be back on Python!

**2016-07-14 update:** Many people raised a question: why was it ported from
Python to Go in the first place? There were several reasons. First, Go's static
binaries nicely solve the packaging problem (we didn't have that many native
packages then and `pip install asciinema` wasn't always reliable due to the fact
that it supported both Python 2 and 3). It later appeared that majority of
people prefer native packages so distributing precompiled binaries wasn't a big
win for this type of project in the end. Second, Go was initially advertised as
a "systems language", and if your program does system stuff like
`select/signal/ioctl` then Go should be perfect, right? Well, it appears that Go
excels (and was built for) slightly different things (multi-core concurrency,
networking, distributed systems). It is no longer advertised as a "systems
language" by its authors. Third, Go's static type system with type inference and
functions as first class citizens felt like a nice bonus. In reality, the lack
of generics forces you to write lots of boilerplate and repetitive code. 20
lines of boilerplate, imperative code is not simpler and easier to understand
(like some Go defendants claim) than 2 lines of higher level code because it
adds noise to the essence of algorithm. When reading code you don't need that
level of granularity in most cases. Well, at least I don't need it :) Fourth, it
was interesting to apply my knowledge of this domain to a language with
different qualities. I would lie if I said having fun wasn't part of the thing.
