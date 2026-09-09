#!/usr/bin/perl
#
# Display the picture of the day
#
# Version 1.1.0 (C) 9.2025 by Beat Rubischon <beat@0x1b.ch>
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
use strict;
use warnings;
use POSIX qw(uname);
use Cwd qw(cwd);
use File::Copy;

my $debug=1;
my $today;

#
# mapping
my %pic=(
);

#
# open debug log
if ($debug) {
  open LOG, ">".$ENV{'HOME'}."/Library/Logs/Grayscale.log";
  select LOG;
  $|=1;
  select STDOUT;
}

#
# fork off sleepwatcher
my $pid=open WATCH, "-|";
if ($pid == 0) {
  exec cwd()."/sleepwatcher", "-w", "/bin/echo";
  exit;
}

#
# main loop
while(1) {

  # get current time
  my $now=time;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime($now);

  if ($debug) {
    print LOG "now: ".scalar localtime($now);
  }

  # check if we have a new day
  if (! defined $today or $today < $yday or $today != 0 and $yday == 0) {
    $today=$yday;
    my $mmdd=sprintf "%02i%02i", $mon+1, $mday;
    if ($debug) {
      print LOG ", image: $mmdd";
    }
    unlink $ENV{'HOME'}."/Pictures/Wallpaper.jpeg";
    copy(cwd()."/Pictures/".$pic{$mmdd},
      $ENV{'HOME'}."/Pictures/Wallpaper.jpeg");

    my @uname=uname();
    my $major=$uname[2];
    $major=~s/\..*$//;
    if ($major < 23) {
      # pre Sonoma aka macOS 14 aka Darwin 23
      system "killall Dock";
    } else {
      # Sonoma and later
      system "killall WallpaperAgent";
    }
  }

  # take a nap until tomorrow
  my $sleep=(23-$hour)*3600 + (59-$min)*60 + (59-$sec) + 2;
  if ($debug) {
    print LOG ", next: ".scalar localtime($now + $sleep)."\n";
  }

  # sleep and listen to sleepwatcher
  my $rin="";
  my $rout;
  vec($rin,fileno(WATCH),1) = 1;
  if (select($rout=$rin, undef, undef, $sleep)) {
    my $byte;
    sysread(WATCH, $byte, 1);
    if ($debug) {
      print LOG "...returned from suspend...\n";
      sleep(5);
    }
  }
}
