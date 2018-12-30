+++
date = "2018-12-30T15:00:00+01:00"
title = "Archival of unclaimed recordings"

+++

Since asciinema's inception in 2012 there were over 200,000 asciicasts uploaded
to asciinema.org 🎉😻.

As of today (end of 2018) there are ~85,000 unclaimed recordings, which are ones
that have been uploaded by anonymous users, who never linked their installation
to their asciinema.org account.

Most of these unclaimed recordings are "abandoned" (recorded, watched once,
forgotten), therefore we're going to archive them, and enable daily
auto-archival ([related
PR](https://github.com/asciinema/asciinema-server/pull/333)) on asciinema.org
soon.

## What's auto-archival?

The idea behind this feature is to automatically "garbage collect" all unclaimed
recordings. It will ensure the recordings that are preserved are linked to real
user accounts, and these users can potentially be reached by email (abuse
reports etc). This will eventually also clean up the storage (save some bucks on
hosting).

## How does this affect me?

If you haven't linked your local installation to asciinema.org account (via
`asciinema auth` command), on each upload you're going to see this message
printed in the terminal:

    View the recording at:

        https://asciinema.org/a/159P2NxIoO6vkGS4lM259Y72A

    This installation of asciinema recorder hasn't been linked to any localhost
    account. All unclaimed recordings (from unknown installations like this one)
    are automatically archived 7 days after upload.

    If you want to preserve all recordings made on this machine, connect this
    installation with localhost account by opening the following link:

        https://asciinema.org/connect/<your-install-id>

Archived recordings won't be deleted, they'll be hidden from listings and
inaccessible via direct link. Actual removal from database and file store will
happen some time after archival, but probably not sooner than few weeks/months
after archival. For the time being we're gonna keep them for a while, and figure
out what's a reasonable TTL for pruning them.

## Schedule for enabling auto-archival on asciinema.org

The above warning message is already active on asciinema.org, however actual
archival is not enabled yet. We're planning to enable archival on 31st
January 2019. On that day all existing unclaimed recordings will be archived,
and all new ones that are not claimed within 7 days from upload will be
auto-archived (daily).

## How can I make sure I don't lose my recordings?

First thing to do is to run `asciinema auth` today, to link your installation to
asciinema.org account (especially if you have
[embedded](https://asciinema.org/docs/embedding) your recordings in a place like
your project documentation, publicly shared slide deck etc).

Linking your installation to online account will ensure no recording uploaded
from this machine will be subject to archival. It will not un-archive already
archived recordings, but it will prevent archival of the already uploaded ones
which are less than 7 days old.

If after doing the above you don't see the recording(s) on your profile page
then most likely they were uploaded from a different machine (or different local
system account). More about this
[here](https://discourse.asciinema.org/t/how-can-i-delete-a-recording-from-asciinema-org/24).
In such case send email to admin@asciinema.org and we'll help you restore it.
