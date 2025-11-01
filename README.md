# NAME

HTTP::BrowserDetect - Determine Web browser, version, and platform from an HTTP user agent string

# VERSION

version 3.45

# SYNOPSIS

    use HTTP::BrowserDetect ();

    my $user_agent_string
        = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36';
    my $ua = HTTP::BrowserDetect->new($user_agent_string);

    # Print general information
    print 'Browser: ' . $ua->browser_string . "\n" if $ua->browser_string;
    print 'Version: ' . $ua->browser_version . $ua->browser_beta . "\n" if $ua->browser_version;
    print 'OS: ' . $ua->os_string . "\n" if $ua->os_string;

    # Detect operating system
    if ( $ua->windows ) {
        if ( $ua->winnt ) {
            # do something
        }
        if ( $ua->win95 ) {
            # do something
        }
    }
    print "Mac\n" if $ua->macosx;

    # Detect browser vendor and version
    print "Safari\n" if $ua->safari;
    print "MSIE\n" if $ua->ie;
    print "Mobile\n" if $ua->mobile;
    if ( $ua->browser_major(4) ) {
        if ( $ua->browser_minor > .5 ) {
            # ...;
        }
    }
    if ( $ua->browser_version > 4.5 ) {
        # ...;
    }

# DESCRIPTION

The HTTP::BrowserDetect object does a number of tests on an HTTP user agent
string. The results of these tests are available via methods of the object.

For an online demonstration of this module's parsing, you can check out
[https://www.browserdetect.org/](https://www.browserdetect.org/)

This module was originally based upon the JavaScript browser detection
code available at
[http://www.mozilla.org/docs/web-developer/sniffer/browser\_type.html](http://www.mozilla.org/docs/web-developer/sniffer/browser_type.html).

# CONSTRUCTOR AND STARTUP

## new()

    HTTP::BrowserDetect->new( $user_agent_string )

The constructor may be called with a user agent string specified. Otherwise, it
will use the value specified by $ENV{'HTTP\_USER\_AGENT'}, which is set by the
web server when calling a CGI script.

# SUBROUTINES/METHODS

# Browser Information

## browser()

Returns the browser, as one of the following values:

chrome, firefox, ie, opera, safari, adm, applecoremedia, blackberry,
brave, browsex, dalvik, elinks, links, lynx, emacs, epiphany, galeon,
konqueror, icab, lotusnotes, mosaic, mozilla, netfront, netscape,
n3ds, dsi, obigo, polaris, pubsub, realplayer, seamonkey, silk,
staroffice, ucbrowser, webtv, samsung

If the browser could not be identified (either because unrecognized
or because it is a robot), returns `undef`.

## browser\_string()

Returns a human formatted version of the browser name. These names are
subject to change and are meant for display purposes. This may include
information additional to what's in browser() (e.g. distinguishing
Firefox from Iceweasel).

If the user agent could not be identified, or if it was identified as
a robot instead, returns `undef`.

# Browser Version

Please note that that the version(), major() and minor() methods have been
deprecated as of release 1.78 of this module. They should be replaced
with browser\_version(), browser\_major(), browser\_minor(), and browser\_beta().

The reasoning behind this is that version() method will, in the case of Safari,
return the Safari/XXX numbers even when Version/XXX numbers are present in the
UserAgent string (i.e. it will return incorrect versions for Safari in
some cases).

## browser\_version()

Returns the browser version (major and minor) as a string. For
example, for Chrome 36.0.1985.67, this returns "36.0".

## browser\_major()

Returns the major part of the version as a string. For example, for
Chrome 36.0.1985.67, this returns "36".

Returns undef if no version information can be detected.

## browser\_minor()

Returns the minor part of the version as a string. This includes the
decimal point; for example, for Chrome 36.0.1985.67, this returns
".0".

Returns undef if no version information can be detected.

## browser\_beta()

Returns any part of the version after the major and minor version, as
a string. For example, for Chrome 36.0.1985.67, this returns
".1985.67". The beta part of the string can contain any type of
alphanumeric characters.

Returns undef if no version information can be detected. Returns an
empty string if version information is detected but it contains only
a major and minor version with nothing following.

# Operating System

## os()

Returns one of the following strings, or `undef`:

    windows, winphone, mac, macosx, linux, android, ios, os2, unix, vms,
    chromeos, firefoxos, ps3, psp, rimtabletos, blackberry, amiga, brew

## os\_string()

Returns a human formatted version of the OS name.  These names are
subject to change and are really meant for display purposes. This may
include information additional to what's in os() (e.g. distinguishing
various editions of Windows from one another) (although for a way to
do that that's more suitable for use in program logic, see below under
"OS related properties").

Returns `undef` if no OS information could be detected.

## os\_version(), os\_major(), os\_minor(), os\_beta()

Returns version information for the OS, if any could be detected. The
format is the same as for the browser\_version() functions.

# Mobile Devices

## mobile()

Returns true if the browser appears to belong to a mobile phone or
similar device (i.e. one small enough that the mobile version of a
page is probably preferable over the desktop version).

In previous versions, tablet devices sometimes had mobile() return
true. They are now mutually exclusive.

## tablet()

Returns true if the browser appears to belong to a tablet device.

## device()

Returns the type of mobile / tablet hardware, if it can be detected.

Currently returns one of: android, audrey, avantgo, blackberry, dsi, iopener, ipad,
iphone, ipod, kindle, n3ds, palm, ps3, psp, wap, webos, winphone.

Returns `undef` if this is not a tablet/mobile device or no hardware
information can be detected.

## device\_string()

Returns a human formatted version of the hardware device name.  These names are
subject to change and are really meant for display purposes.  You should use
the device() method in your logic. This may include additional
information (such as the model of phone if it is detectable).

Returns `undef` if this is not a portable device or if no device name
can be detected.

# Robots

## robot()

If the user agent appears to be a robot, spider, crawler, or other
automated Web client, this returns one of the following values:

lwp, slurp, yahoo, bingbot, msnmobile, msn, msoffice, ahrefs,
altavista, apache, askjeeves, baidu, curl, facebook, getright,
googleadsbot, googleadsense, googlebotimage, googlebotnews,
googlebotvideo, googlefavicon, googlemobile, google, golib, indy,
infoseek, ipsagent, linkchecker, linkexchange, lycos, malware,
mj12bot, nutch, phplib, puf, pythonurllib, rubylib, scooter, specialarchiver,
wget, yandexbot, yandeximages, java, headlesschrome, amazonbot,
unknown

Returns "unknown" when the user agent is believed to be a robot but
is not identified as one of the above specific robots.

Returns `undef` if the user agent is not a robot or cannot be
identified.

Note that if a robot crafts a user agent designed to impersonate a
particular browser, we generally set properties appropriate to both
the actual robot, and the browser it is impersonating. For example,
googlebot-mobile pretends to be mobile safari so that it will get
mobile versions of pages. In this case, browser() will return
'safari', the properties will generally be set as if for Mobile
Safari, the 'robot' property will be set, and robot() will return
'googlemobile'.

### lib()

Returns true if the user agent appears to be an HTTP library or tool
(e.g. LWP, curl, wget, java). Generally libraries are also classified
as robots, although it is impossible to tell whether they are being
operated by an automated system or a human.

### robot\_string()

Returns a human formatted version of the robot name. These names are
subject to change and are meant for display purposes. This may include
additional information (e.g. robots which return "unknown" from
robot() generally can be identified in a human-readable fashion by
reading robot\_string() ).

### robot\_id()

This method is currently in beta.

Returns an id consisting of lower case letters, numbers and dashes.  This id
will remain constant, so you can use it for matching against a particular
robot.  The ids were introduced in version 3.14.  There may still be a few
corrections to ids in subsequent releases.  Once this method becomes stable the
ids will also be frozen.

### all\_robot\_ids()

This method returns an `ArrayRef` of all possible `robot_id` values.

## robot\_version(), robot\_major(), robot\_minor(), robot\_beta()

Returns version information for the robot, if any could be
detected. The format is the same as for the browser\_version()
functions.

Note that if a robot crafts a user agent designed to impersonate a
particular browser, we generally return results appropriate to both
the actual robot, and the browser it is impersonating. For example,
googlebot-mobile pretends to be mobile safari so that it will get
mobile versions of pages. In this case, robot\_version() will return
the version of googlebot-mobile, and browser\_version() will return the
version of Safari that googlebot-mobile is impersonating.

# Browser Properties

Operating systems, devices, browser names, rendering engines, and
true-or-false methods (e.g. "mobile" and "lib") are all browser
properties. For example, calling browser\_properties() for Mobile
Safari running on an Android will return this list:

('android', 'device', 'mobile', 'mobile\_safari', 'safari', 'webkit')

## browser\_properties()

Returns all properties for this user agent, as a list. Note that
because a large number of cases must be considered, this will take
significantly more time than simply querying the particular methods
you care about.

A mostly complete list of properties follows (i.e. each of these
methods is both a method you can call, and also a property that may
be in the list returned by browser\_properties() ). In addition to this
list, robot(), lib(), device(), mobile(), and tablet() are all
browser properties.

## OS related properties

The following methods are available, each returning a true or false value.
Some methods also test for the operating system version. The indentations
below show the hierarchy of tests (for example, win2k is considered a type of
winnt, which is a type of win32)

### windows()

    win16 win3x win31
    win32
        winme win95 win98
        winnt
            win2k winxp win2k3 winvista win7
            win8
                win8_0 win8_1
            win10
                win10_0
    wince
    winphone
        winphone7 winphone7_5 winphone8 winphone10

### dotnet()

### x11()

### webview()

### chromeos()

### firefoxos()

### mac()

mac68k macppc macosx ios

### os2()

### bb10()

### rimtabletos()

### unix()

    sun sun4 sun5 suni86 irix irix5 irix6 hpux hpux9 hpux10
    aix aix1 aix2 aix3 aix4 linux sco unixware mpras reliant
    dec sinix freebsd bsd

### vms()

### amiga()

### ps3gameos()

### pspgameos()

It may not be possible to detect Win98 in Netscape 4.x and earlier. On Opera
3.0, the userAgent string includes "Windows 95/NT4" on all Win32, so you can't
distinguish between Win95 and WinNT.

## Browser related properties

The following methods are available, each returning a true or false value.
Some methods also test for the browser version, saving you from checking the
version separately.

### adm

### aol aol3 aol4 aol5 aol6

### applecoremedia

### avantgo

### browsex

### chrome

### dalvik

### emacs

### epiphany

### firefox

### galeon

### icab

### ie ie3 ie4 ie4up ie5 ie5up ie55 ie55up ie6 ie7 ie8 ie9 ie10 ie11

### ie\_compat\_mode

The ie\_compat\_mode is used to determine if the IE user agent is for
the compatibility mode view, in which case the real version of IE is
higher than that detected. The true version of IE can be inferred from
the version of Trident in the engine\_version method.

### konqueror

### lotusnotes

### lynx links elinks

### mobile\_safari

### mosaic

### mozilla

### neoplanet neoplanet2

### netfront

### netscape nav2 nav3 nav4 nav4up nav45 nav45up navgold nav6 nav6up

### obigo

### opera opera3 opera4 opera5 opera6 opera7

### polaris

### pubsub

### realplayer

The realplayer method above tests for the presence of either the RealPlayer
plug-in "(r1 " or the browser "RealPlayer".

### realplayer\_browser

The realplayer\_browser method tests for the presence of the RealPlayer
browser (but returns 0 for the plugin).

### safari

### samsung

### seamonkey

### silk

### staroffice

### ucbrowser

### webtv

Netscape 6, even though it's called six, in the User-Agent string has version
number 5. The nav6 and nav6up methods correctly handle this quirk. The Firefox
test correctly detects the older-named versions of the browser (Phoenix,
Firebird).

## Device related properties

The following methods are available, each returning a true or false value.

### android

### audrey

### avantgo

### blackberry

### dsi

### iopener

### iphone

### ipod

### ipad

### kindle

### kindlefire

### n3ds

### palm

### webos

### wap

Note that 'wap' indicates that the device is capable of WAP, not
necessarily that the device is limited to WAP only. Most modern WAP
devices are also capable of rendering standard HTML.

### psp

### ps3

## Robot properties

These methods are now deprecated and will be removed in a future release.
Please use the `robot()` and `robot_id()` methods to identify the bots.  Use
`robot_id()` if you need to match on a string, since the value that is
returned by `robot` could possibly change in a future release.

The following additional methods are available, each returning a true or false
value. This is by no means a complete list of robots that exist on the Web.

### ahrefs

### altavista

### apache

### askjeeves

### baidu

### bingbot

### curl

### facebook

### getright

### golib

### google

### googleadsbot

### googleadsense

### googlemobile

### indy

### infoseek

### ipsagent

### java

### linkexchange

### lwp

### lycos

### malware

### mj12bot

### msn

### msoffice

### puf

### pythonurllib

### rubylib

### slurp

### wget

### yahoo

### yandex

### yandeximages

### headlesschrome

## Engine properties

The following properties indicate if a particular rendering engine is
being used.

### webkit

### blink

### gecko

### trident

### presto

### khtml

# Other methods

## user\_agent()

Returns the value of the user agent string.

Calling this method with a parameter to set the user agent has now
been removed; please use HTTP::BrowserDetect->new() to pass the user
agent string.

## u2f()

Returns true if this browser and version are known to support Universal Second
Factor (U2F).  This method will need future updates as more browsers fully
support this standard.

## country()

Returns the country string as it may be found in the user agent string. This
will be in the form of an upper case 2 character code. ie: US, DE, etc

## language()

Returns the language string as it is found in the user agent string. This will
be in the form of an upper case 2 character code. ie: EN, DE, etc

## engine()

Returns the rendering engine, one of the following:

gecko, webkit, blink, khtml, trident, ie, presto, netfront

Note that Chrome versions 38 and above return "blink", while earlier
Chrome versions and other WebKit-based browsers return "webkit". This is
a change from previous versions of this library which returned "webkit"
for all WebKit-based browsers including Chrome/Blink.

Returns `undef` if none of the above rendering engines can be
detected.

## engine\_string()

Returns a human formatted version of the rendering engine.

Note that Chrome versions 38 and above return "Blink", while earlier
Chrome versions and other WebKit-based browsers return "WebKit". This is
a change from previous versions of this library which returned "WebKit"
for all WebKit-based browsers including Chrome/Blink.

Returns `undef` if none of the known rendering engines can be
detected.

## engine\_version(), engine\_major(), engine\_minor(), engine\_beta()

Returns version information for the rendering engine, if any could be
detected. The format is the same as for the browser\_version()
functions.

# Deprecated methods

## device\_name()

Deprecated alternate name for device\_string()

## version()

This is probably not what you want.  Please use either browser\_version() or
engine\_version() instead.

Returns the version (major and minor) as a string.

This function returns wrong values for some Safari versions, for
compatibility with earlier code. browser\_version() returns correct
version numbers for Safari.

## major()

This is probably not what you want. Please use either browser\_major()
or engine\_major() instead.

Returns the integer portion of the browser version as a string.

This function returns wrong values for some Safari versions, for
compatibility with earlier code. browser\_version() returns correct
version numbers for Safari.

## minor()

This is probably not what you want. Please use either browser\_minor()
or engine\_minor() instead.

Returns the decimal portion of the browser version as a string.

This function returns wrong values for some Safari versions, for
compatibility with earlier code. browser\_version() returns correct
version numbers for Safari.

## beta()

This is probably not what you want. Please use browser\_beta() instead.

Returns the beta version, consisting of any characters after the major
and minor version number, as a string.

This function returns wrong values for some Safari versions, for
compatibility with earlier code. browser\_version() returns correct
version numbers for Safari.

## public\_version(), public\_major(), public\_minor(), public\_beta()

Deprecated.  Please use browser\_version() and related functions
instead.

## gecko\_version()

If a Gecko rendering engine is used (as in Mozilla or Firefox), returns the
engine version. If no Gecko browser is being used, or the version
number can't be detected, returns undef.

This is an old function, preserved for compatibility; please use
engine\_version() in new code.

# CREDITS

Lee Semel, lee@semel.net (Original Author)

Peter Walsham (co-maintainer)

Olaf Alders, `olaf at wundercounter.com` (co-maintainer)

# ACKNOWLEDGEMENTS

Thanks to the following for their contributions:

cho45

Leonardo Herrera

Denis F. Latypoff

merlynkline

Simon Waters

Toni Cebrin

Florian Merges

david.hilton.p

Steve Purkis

Andrew McGregor

Robin Smidsrod

Richard Noble

Josh Ritter

Mike Clarke

Marc Sebastian Pelzer

Alexey Surikov

Maros Kollar

Jay Rifkin

Luke Saunders

Jacob Rask

Heiko Weber

Jon Jensen

Jesse Thompson

Graham Barr

Enrico Sorcinelli

Olivier Bilodeau

Yoshiki Kurihara

Paul Findlay

Uwe Voelker

Douglas Christopher Wilson

John Oatis

Atsushi Kato

Ronald J. Kimball

Bill Rhodes

Thom Blake

Aran Deltac

yeahoffline

David Ihnen

Hao Wu

Perlover

Daniel Stadie

ben hengst

Andrew Moise

Atsushi Kato

Marco Fontani

Nicolas Doye

# TO DO

POD coverage is not 100%.

# SEE ALSO

"Browser ID (User-Agent) Strings", [http://www.zytrax.com/tech/web/browser\_ids.htm](http://www.zytrax.com/tech/web/browser_ids.htm)

[HTML::ParseBrowser](https://metacpan.org/pod/HTML%3A%3AParseBrowser).

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTTP::BrowserDetect

You can also look for information at:

- GitHub Source Repository

    [https://github.com/oalders/http-browserdetect](https://github.com/oalders/http-browserdetect)

- Reporting Issues

    [https://github.com/oalders/http-browserdetect/issues](https://github.com/oalders/http-browserdetect/issues)

- Search CPAN

    [https://metacpan.org/module/HTTP::BrowserDetect](https://metacpan.org/module/HTTP::BrowserDetect)

# CONTRIBUTING

Patches are certainly welcome, with many thanks for the excellent contributions
which have already been received. The preferred method of patching would be to
fork the GitHub repo and then send a pull request.

Please include a test case as this will speed up the time to release your
changes. Just edit t/useragents.json so that the test coverage includes any
changes you have made. Please open a GitHub issue if you have any questions.

# AUTHORS

- Lee Semel <lee@semel.net>
- Peter Walsham
- Olaf Alders <olaf@wundercounter.com> (current maintainer)

# COPYRIGHT AND LICENSE

This software is copyright (c) 1999 by Lee Semel.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
