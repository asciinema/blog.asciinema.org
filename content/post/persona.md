+++
date = "2013-10-24T18:47:08+01:00"
title = "asciinema switching to Mozilla Persona for login"

+++

So far you could log in to [asciinema](http://asciinema.org) using your Github
or Twitter account via OAuth. The idea behind this was twofold:

* avoid passwords,
* make it as simple as possible.

Passwords are insecure, inconvenient and annoying. Inconvenience of passwords
was nicely summed up by [Xavier](https://twitter.com/xavez) in his
[tweet](https://twitter.com/xavez/status/360417837514358785) saying _"password
reset is the new login"_. So the OAuth flow, being very simple for the user
(given he/she is already logged in at the provider), helped
achieving the initial goals.

And while OAuth based login worked totally fine it made asciinema dependent on
commercial vendors for no good reason. OAuth was designed for API authorization
between applications, not for user authentication. asciinema doesn't need
access to user's Github repositories nor user's tweets. It just needs the
ability to authenticate a user. Also, the assumption that everyone has either
Github or Twitter account is simply wrong.

The assumption that everyone has an email address is a correct one though.
E-mail is ubiquitous and everyone remembers his/her own address. Can't we just
use it as an ID on the web? [Mozilla](http://mozilla.org) believes we can and
we should. [Mozilla Persona](https://login.persona.org/), a reference
implementation of BrowserID protocol, puts the email address at the center of
authentication and gives us simple, privacy-sensitive single sign-in solution.

asciinema team believes in Mozilla's mission for promoting openness and
innovation on the web, and thus we switch to Persona based authentication,
replacing the existing OAuth based flow. If you have an existing asciinema
account then fear not, you won't lose access to it. When signing in just use
the same email address that you assigned to your account. If you don't remember
which one you have used (or you haven't set the email address at all) then
sign in (with your preferred email address) and you'll be given an option to
locate your existing account by doing the OAuth dance for one last time.

Let us know what you think about this change. Enjoy!
