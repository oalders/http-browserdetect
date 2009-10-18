#!/usr/local/bin/perl

use vars qw(@tests $loaded);


BEGIN { $| = 1; }
END {print "not ok 1\n" unless $loaded;}

use HTTP::BrowserDetect;
$loaded = 1;

@tests = (
      ['Mozilla/1.1 (Windows 3.0; I)','1.1','Netscape','Win3x',undef,qw(netscape windows win3x win16)],
      ['Mozilla/1.1 (Windows 3.1; I)','1.1','Netscape','Win3x',undef,qw(netscape windows win31 win3x win16)],
      ['Mozilla/2.0 (Win95; I)','2.0','Netscape','Win95',undef,qw(netscape nav2 windows win32 win95)],
      ['Mozilla/2.0 (compatible; MSIE 3.01; Windows 95)','3.01','MSIE','Win95',undef,qw(ie ie3 windows win32 win95)],
      ['Mozilla/2.0 (compatible; MSIE 3.01; Windows NT)','3.01','MSIE','WinNT',undef,qw(ie ie3 windows win32 winnt)],
      ['Mozilla/2.0 (compatible; MSIE 3.0; AOL 3.0; Windows 95)','3.0','AOL Browser','Win95',undef,qw(ie ie3 windows win32 win95 aol aol3)],
      ['Mozilla/2.0 (compatible; MSIE 4.0; Windows 95)','4.0','MSIE','Win95',undef,qw(ie ie4 ie4up windows win32 win95)],
      ['Mozilla/3.0 (compatible; MSIE 4.0; Windows 95)','4.0','MSIE','Win95',undef,qw(ie ie4 ie4up windows win32 win95)],
      ['Mozilla/4.0 (compatible; MSIE 4.01; Windows 95)','4.01','MSIE','Win95',undef,qw(ie ie4 ie4up windows win32 win95)],
      ['Mozilla/4.0 (compatible; MSIE 5.0b2; Windows NT)','5.0','MSIE','WinNT',undef,qw(ie ie5 ie5up ie4up windows win32 winnt)],
      ['Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)','5.5','MSIE','WinNT',undef,qw(ie ie5 ie5up ie55 ie55up ie4up windows win32 winnt)],
      ['Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0) via proxy gateway Something/1.23','5.5','MSIE','Win2k',undef,qw(ie ie5 ie5up ie55 ie55up ie4up windows win32 winnt win2k)],
      ['Mozilla/3.0 (Macintosh; I; PPC)','3.0','Netscape','Mac',undef,qw(netscape nav3 mac macppc)],
      ['Mozilla/4.0 (compatible; MSIE 5.0; Win32)','5.0','MSIE',undef,undef,qw(ie ie4up ie5 ie5up windows win32)],
      ['Mozilla/4.0 (compatible; Opera/3.0; Windows 4.10) 3.50','3.0','Opera',undef,undef,qw(opera opera3 windows)],
      ['Mozilla/4.0 (compatible; MSIE 5.0b1; Windows NT 5.0)','5.0','MSIE','Win2k',undef,qw(ie ie4up ie5 ie5up windows win32 winnt win2k)],
      ['Mozilla/4.06 [en] (Win98; I ;Nav)','4.06','Netscape','Win98',undef,qw(netscape nav4 nav4up windows win32 win98)], 
      ['Mozilla/4.5 [en] (X11; I; FreeBSD 2.2.7-RELEASE i386)','4.5','Netscape','Unix',undef,qw(netscape nav4 nav4up nav45 nav45up bsd freebsd unix x11)],
      ['Mozilla/3.03Gold (Win95; I)','3.03','Netscape','Win95', undef,qw(netscape nav3 navgold windows win32 win95)],
      ['Wget/1.4.5','1.4',undef,undef,undef,qw(wget robot)],
      ['libwww-perl/5.11','5.11',undef,undef,undef,qw(lwp robot)],
      ['GetRight/3.2.1','3.2',undef,undef,undef,qw(getright robot)],
      ['Mozilla/3.0 (compatible; StarOffice/5.1; Linux)','5.1',undef,'Linux',undef,qw(linux unix staroffice)],
      ['Mozilla/3.0 (compatible; StarOffice/5.1; Win32)','5.1',undef,undef,undef,qw(win32 windows staroffice)],
      ['iCab/Pre2.0 (Macintosh; I; PPC)','2.0',undef,'Mac',undef,qw(mac macppc icab)],
      ['Konqueror/1.1.2','1.1',undef,undef,undef,qw(konqueror)],
      ['Lotus-Notes/4.5 ( OS/2 )','4.5',undef,'OS2',undef,qw(lotusnotes os2)],
      ['Java1.0.2','0.0',undef,undef,undef,qw(java)],
      ['Googlebot/1.0 (googlebot@googlebot.com http://googlebot.com/)','1.0',undef,undef,undef,qw(google robot)],
      ['Nothing','0.0',undef,undef,undef,qw()],
      [undef,'0.0',undef,undef,undef,qw()],
      ['Nokia-WAP-Toolkit/1.3beta','1.3',undef,undef,undef,qw(wap)],
      ['Nokia7110/1.0 (30.05)','1.0',undef,undef,undef,qw(wap)],
      ['UP.Browser/4.1.2a-XXXX','4.1',undef,undef,undef,qw(wap)],
      ['Wapalizer/1.0','1.0',undef,undef,undef,qw(wap)],
      ['YourWap/1.16','1.16',undef,undef,undef,qw(wap)],
      ['AmigaVoyager/3.3.50 (AmigaOS/PPC)','3.3',undef,undef,undef,qw(amiga)],
      ['AmigaVoyager (compatible; AmigaVoyager; AmigaOS)','0.0',undef,undef,undef,qw(amiga)],
      ['AvantGo 3.2 (compatible; AvantGo 3.2)','0.0',undef,undef,undef,qw(palm avantgo)],
      ['fetch/1.0 FreeBSD/4.0-CURRENT (i386)','1.0',undef,'Unix',undef,qw(bsd freebsd unix robot)],
      ['Emacs-W3/2.1.105 URL/1.267 ((Unix?) ; TTY ; sparc-sun-solaris2.3)','2.1',undef,'Unix',undef,qw(emacs sun unix)],
      ['Mozilla/5.001 (windows; U; NT4.0; en-us) Gecko/25250101','5.001','Netscape','WinNT',undef,qw(netscape nav4up nav45up windows winnt win32 gecko nav6 nav6up mozilla gecko)],
      ['Mozilla/5.001 (Macintosh; N; PPC; ja) Gecko/25250101 MegaCorpBrowser/1.0 (MegaCorp, Inc.)','5.001','Netscape','Mac',undef,qw(netscape nav4up nav45up nav6 nav6up mac macppc mozilla gecko)],
      ['Mozilla/9.876 (X11; U; Linux 2.2.12-20 i686, en) Gecko/25250101 Netscape/5.432b1 (C-MindSpring)','5.432','Netscape','Linux',undef,qw(netscape nav4up nav45up nav6 nav6up linux unix mozilla gecko x11)],
      ['TinyBrowser/2.0 (TinyBrowser Comment) Gecko/20201231','2.0',undef,undef,undef,qw(gecko)],
      ['TinyBrowser/2.0 (TinyBrowser Comment) Gecko/20201231','2.000',undef,undef,undef,qw(gecko)],
    
      ['Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.7) Gecko/20040619 Firefox/0.9',
        '0.9',
        'Firefox',
        'Unix',
        1.7,qw(unix freebsd bsd x11 firefox gecko)],

     ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7) Gecko/20040614 Firefox/0.9',
        '0.9',
        'Firefox',
        'WinXP',
        1.7,qw(windows win32 winnt winxp firefox gecko)],
    
     ['Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8a) Gecko/20040416 Firefox/0.8.0+',
        '0.8',
        'Firefox',
        'Win2k',
        '1.8a',qw(windows win32 winnt win2k firefox gecko)],
        
     ['Mozilla/5.0 (X11; U; Linux i686; de-DE; rv:1.6) Gecko/20040207 Firefox/0.8',
        '0.8',
        'Firefox',
        'Linux',
        '1.6',qw(unix linux x11 firefox gecko)],
        
     ['Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.5) Gecko/20031007 Firebird/0.7',
        '0.7',
        'Firefox',
        'WinXP',
        '1.5',qw(windows win32 winnt winxp firefox gecko)],
        
        
     ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.5a) Gecko/20031002 Mozilla Firebird/0.6.1',
        '0.6',
        'Firefox',
        'Linux',
        '1.5a',qw(unix linux x11 firefox gecko)],
        
        
     ['Mozilla/5.0 (Windows; U; WinNT4.0; en-US; rv:1.3a) Gecko/20021207 Phoenix/0.5',
        '0.5',
        'Firefox',
        'WinNT',
        '1.3a',qw(windows win32 winnt firefox gecko)],
       
     ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/124 (KHTML, like Gecko) Safari/125.1',
        '1.25',
        'Safari',
        'Mac OS X',
        undef,qw(mac macosx macppc safari gecko)],
        
         
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/106.2 (KHTML, like Gecko) Safari/100.1',
        '1.0',
        'Safari',
        'Mac OS X',
        undef,qw(mac macosx macppc safari gecko)],
        
      
           
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/74 (KHTML, like Gecko) Safari/74',
        '0.74',
        'Safari',
        'Mac OS X',
        undef,qw(mac macosx macppc safari gecko)],
        
        
      ['BlackBerry7730/3.7.1 UP.Link/5.1.2.5',
        '3.7',
        undef,
        undef,
        undef,qw(blackberry)],
               
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705; .NET CLR 1.1.4322)',
        '6.0',
        'MSIE',
        'Win2k',
        undef,qw(windows winnt win2k win32 ie ie4up ie5up ie55up ie6 dotnet)],
         
        
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
        '6.0',
        'MSIE',
        'WinXP',
        undef,qw(windows winnt winxp win32 ie ie4up ie5up ie55up ie6)],
         
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)',
        '6.0',
        'MSIE',
        'WinXP',
        undef,qw(windows winnt winxp win32 ie ie4up ie5up ie55up ie6 dotnet)],
         
      ['Mozilla/4.0 (compatible; MSIE 5.22; Mac_PowerPC) ',
        '5.22',
        'MSIE',
        'Mac',
        undef,qw(mac macppc ie ie4up ie5 ie5up)],
           
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-US; rv:1.0.2) Gecko/20030208 Netscape/7.02',
        '7.02',
        'Netscape',
        'Mac OS X',
        '1.0.2',qw(mac macppc netscape nav4up nav45up nav6up gecko macosx mozilla)],
      
      ['Mozilla/5.0 (X11; U; Linux 2.4.3-20mdk i586; en-US; rv:0.9.1) Gecko/20010611',
        '5.0',
        'Netscape',
        'Linux',
        '0.9.1',qw(linux netscape nav4up nav45up nav6 nav6up unix x11 gecko mozilla)],
      
           
     );
     
     

print STDERR $HTTP::BrowserDetect::VERSION, "\n";
print "1..".(1+scalar(@tests))."\n"; 
print "ok 1\n";

my $browser = new HTTP::BrowserDetect();
my $test_number = 2;

foreach (@tests) {
    my $fail = 0;
    my @reason = ();
    my ($user_agent, 
        $version, 
        $browser_string, 
        $os_string, 
        $gecko_version,
        @test_names) = @{$_};

    foreach my $obj ('$browser->', 'HTTP::BrowserDetect::') {
	eval("${obj}user_agent(\$user_agent)");
	unless (eval("${obj}os_string()") eq $os_string) {
	    $fail = 1;
	    push @reason, 'os_string = "' . eval("${obj}os_string()") . '"';
	}
	unless (eval("${obj}browser_string()") eq $browser_string) {
	    $fail = 1;
	    push @reason, 'browser_string = "' . eval("${obj}browser_string()") . '"';
	}
	
    unless (eval("${obj}gecko_version()") eq $gecko_version) {
	    $fail = 1;
	    push @reason, 'gecko_version = "' . eval("${obj}gecko_version()") . '"';
	}
	
    my ($major, $minor) = ($version =~ /([\d]*)\.([\d]*)/);
	$minor = 0+".$minor";
	unless (eval("${obj}version(\$version)")) {
	    $fail = 1;
	    push @reason, 'version(' . $version . ') was false';
	}
	unless (eval("${obj}version()") == $version) {
	    $fail = 1;
	    push @reason, 'version() != ' . $version;
	}
	unless (eval("${obj}major(\$major)")) {
	    $fail = 1;
	    push @reason, 'major(' . $major .') was false';
	}
	unless (eval("${obj}major()") == $major) {
	    push @reason, 'major() != ' . $major;
	}
	unless (eval("${obj}minor(\$minor)")) {
	    $fail = 1;
	    push @reason, 'minor(' . $minor .') was false';
	}
	unless (eval("${obj}minor()") == $minor) {
	    $fail = 1;
	    push @reason, 'minor() != ' . $minor;
	}
	my %tests = map{$_=>1} @test_names;
	foreach (@HTTP::BrowserDetect::ALL_TESTS, keys %tests) {
	    unless (eval("${obj}$_()") == $tests{$_}) {
		$fail = 1;
		push @reason, $_;
	    }
	}

	last if $fail;
    }
    if ($fail) {
      print "not ok " , $test_number;
      print STDERR ' user-agent="' , $user_agent, '": ';
      print STDERR join ", ", @reason;
    } else {
      print "ok ", $test_number;
    }
    print "\n";
    $test_number++;
}





