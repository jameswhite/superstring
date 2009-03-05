#!/usr/bin/perl -wT
use strict;
use File::Temp qw/tempfile tempdir/;

my $seed_template="/var/www/sites/wcyd.org/seed.tpl";

$ENV{'PATH'}="/bin:/usr/bin:/usr/local/bin;/sbin:/usr/sbin:/usr/local/sbin";

print "Content-type: text/plain\n\n";
open(STUB,$seed_template) || die "cannot open file:[$seed_template] @!\n";
while(my $line=<STUB>){ print $line; }
close(STUB);
my $git_root = tempdir( "seed.pl.XXXXX", DIR => "/var/tmp", CLEANUP => 1 );
if (-d $git_root){
   system("cd $git_root; /usr/bin/git clone git://github.com/fapestniegd/superstring.git >/dev/null 2>\&1");
   system("cd $git_root/superstring/strings/cfengine; /bin/tar czf - .|/usr/bin/mimencode");
}

