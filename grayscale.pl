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
  "0101" => "7N9A0806.jpeg",
  "0102" => "7N9A0813.jpeg",
  "0103" => "7N9A0835.jpeg",
  "0104" => "7N9A0840.jpeg",
  "0105" => "7N9A0847.jpeg",
  "0106" => "7N9A0861.jpeg",
  "0107" => "7N9A0865.jpeg",
  "0108" => "7N9A0871.jpeg",
  "0109" => "7N9A0873.jpeg",
  "0110" => "7N9A0898.jpeg",
  "0111" => "7N9A0905.jpeg",
  "0112" => "7N9A0914.jpeg",
  "0113" => "7N9A0920.jpeg",
  "0114" => "7N9A0927.jpeg",
  "0115" => "7N9A0940.jpeg",
  "0116" => "7N9A0953.jpeg",
  "0117" => "7N9A0960.jpeg",
  "0118" => "7N9A0973.jpeg",
  "0119" => "7N9A0980.jpeg",
  "0120" => "7N9A0986.jpeg",
  "0121" => "7N9A0987.jpeg",
  "0122" => "7N9A0997.jpeg",
  "0123" => "7N9A1004.jpeg",
  "0124" => "7N9A1008.jpeg",
  "0125" => "7N9A1022.jpeg",
  "0126" => "7N9A1039.jpeg",
  "0127" => "7N9A1044.jpeg",
  "0128" => "7N9A1047.jpeg",
  "0129" => "7N9A1052.jpeg",
  "0130" => "7N9A1056.jpeg",
  "0131" => "7N9A1065.jpeg",
  "0201" => "7N9A1068.jpeg",
  "0202" => "7N9A1069.jpeg",
  "0203" => "7N9A1073.jpeg",
  "0204" => "7N9A1074.jpeg",
  "0205" => "7N9A1078.jpeg",
  "0206" => "7N9A1085.jpeg",
  "0207" => "7N9A1091.jpeg",
  "0208" => "7N9A1130.jpeg",
  "0209" => "7N9A1145.jpeg",
  "0210" => "7N9A1155.jpeg",
  "0211" => "7N9A1159.jpeg",
  "0212" => "7N9A1178.jpeg",
  "0213" => "7N9A1186.jpeg",
  "0214" => "7N9A1211.jpeg",
  "0215" => "7N9A1215.jpeg",
  "0216" => "7N9A1442.jpeg",
  "0217" => "7N9A1449.jpeg",
  "0218" => "7N9A1452.jpeg",
  "0219" => "7N9A1454.jpeg",
  "0220" => "7N9A1457.jpeg",
  "0221" => "7N9A1463.jpeg",
  "0222" => "7N9A1484.jpeg",
  "0223" => "7N9A1488.jpeg",
  "0224" => "7N9A1494.jpeg",
  "0225" => "7N9A1496.jpeg",
  "0226" => "7N9A1517.jpeg",
  "0227" => "7N9A1532.jpeg",
  "0228" => "7N9A1538.jpeg",
  "0229" => "7N9A1535.jpeg",	# leap day
  "0301" => "7N9A1546.jpeg",
  "0302" => "7N9A1548.jpeg",
  "0303" => "7N9A1554.jpeg",
  "0304" => "7N9A1559.jpeg",
  "0305" => "7N9A1566.jpeg",
  "0306" => "7N9A1567.jpeg",
  "0307" => "7N9A1576.jpeg",
  "0308" => "7N9A1791.jpeg",
  "0309" => "7N9A1869.jpeg",
  "0310" => "7N9A1876.jpeg",
  "0311" => "7N9A1880.jpeg",
  "0312" => "7N9A1888.jpeg",
  "0313" => "7N9A1891.jpeg",
  "0314" => "7N9A1904.jpeg",
  "0315" => "7N9A1907.jpeg",
  "0316" => "7N9A1912.jpeg",
  "0317" => "7N9A1923.jpeg",
  "0318" => "7N9A1931.jpeg",
  "0319" => "7N9A1934.jpeg",
  "0320" => "7N9A1936.jpeg",
  "0321" => "7N9A1940.jpeg",
  "0322" => "7N9A1946.jpeg",
  "0323" => "7N9A2001.jpeg",
  "0324" => "7N9A2002.jpeg",
  "0325" => "7N9A2008.jpeg",
  "0326" => "7N9A2011.jpeg",
  "0327" => "7N9A2022.jpeg",
  "0328" => "7N9A2039.jpeg",
  "0329" => "7N9A2053.jpeg",
  "0330" => "7N9A2058.jpeg",
  "0331" => "7N9A2063.jpeg",
  "0401" => "7N9A2066.jpeg",
  "0402" => "7N9A2075.jpeg",
  "0403" => "7N9A2078.jpeg",
  "0404" => "7N9A2102.jpeg",
  "0405" => "7N9A2107.jpeg",
  "0406" => "7N9A2113.jpeg",
  "0407" => "7N9A2127.jpeg",
  "0408" => "7N9A2130.jpeg",
  "0409" => "7N9A2141.jpeg",
  "0410" => "7N9A2142.jpeg",
  "0411" => "7N9A2173.jpeg",
  "0412" => "7N9A2180.jpeg",
  "0413" => "7N9A2185.jpeg",
  "0414" => "7N9A2186.jpeg",
  "0415" => "7N9A2190.jpeg",
  "0416" => "7N9A2196.jpeg",
  "0417" => "7N9A2227.jpeg",
  "0418" => "7N9A2238.jpeg",
  "0419" => "7N9A2243.jpeg",
  "0420" => "7N9A2248.jpeg",
  "0421" => "7N9A2252.jpeg",
  "0422" => "7N9A2259.jpeg",
  "0423" => "7N9A2275.jpeg",
  "0424" => "7N9A2278.jpeg",
  "0425" => "7N9A2285.jpeg",
  "0426" => "7N9A2438.jpeg",
  "0427" => "7N9A2446.jpeg",
  "0428" => "7N9A2451.jpeg",
  "0429" => "7N9A2467.jpeg",
  "0430" => "7N9A2471.jpeg",
  "0501" => "7N9A2483.jpeg",
  "0502" => "7N9A2486.jpeg",
  "0503" => "7N9A2491.jpeg",
  "0504" => "7N9A2494.jpeg",
  "0505" => "7N9A2505.jpeg",
  "0506" => "7N9A2508.jpeg",
  "0507" => "7N9A2525.jpeg",
  "0508" => "7N9A2531.jpeg",
  "0509" => "7N9A2537.jpeg",
  "0510" => "7N9A2541.jpeg",
  "0511" => "7N9A2543.jpeg",
  "0512" => "7N9A2553.jpeg",
  "0513" => "7N9A2556.jpeg",
  "0514" => "7N9A2566.jpeg",
  "0515" => "7N9A2568.jpeg",
  "0516" => "7N9A2573.jpeg",
  "0517" => "7N9A2576.jpeg",
  "0518" => "7N9A2577.jpeg",
  "0519" => "7N9A2595.jpeg",
  "0520" => "7N9A2603.jpeg",
  "0521" => "7N9A2610.jpeg",
  "0522" => "7N9A2622.jpeg",
  "0523" => "7N9A2630.jpeg",
  "0524" => "7N9A2647.jpeg",
  "0525" => "7N9A2659.jpeg",
  "0526" => "7N9A2662.jpeg",
  "0527" => "7N9A2666.jpeg",
  "0528" => "7N9A2701.jpeg",
  "0529" => "7N9A2709.jpeg",
  "0530" => "7N9A2714.jpeg",
  "0531" => "7N9A2796.jpeg",
  "0601" => "7N9A2803.jpeg",
  "0602" => "7N9A2806.jpeg",
  "0603" => "7N9A2816.jpeg",
  "0604" => "7N9A2825.jpeg",
  "0605" => "7N9A2828.jpeg",
  "0606" => "7N9A2830.jpeg",
  "0607" => "7N9A2835.jpeg",
  "0608" => "7N9A2836.jpeg",
  "0609" => "7N9A2839.jpeg",
  "0610" => "7N9A2864.jpeg",
  "0611" => "7N9A2890.jpeg",
  "0612" => "7N9A2946.jpeg",
  "0613" => "7N9A3298.jpeg",
  "0614" => "7N9A3506.jpeg",
  "0615" => "7N9A3516.jpeg",
  "0616" => "7N9A3520.jpeg",
  "0617" => "7N9A3528.jpeg",
  "0618" => "7N9A3535.jpeg",
  "0619" => "7N9A3558.jpeg",
  "0620" => "7N9A3567.jpeg",
  "0621" => "7N9A3573.jpeg",
  "0622" => "7N9A3694.jpeg",
  "0623" => "7N9A3697.jpeg",
  "0624" => "7N9A3702.jpeg",
  "0625" => "7N9A3711.jpeg",
  "0626" => "7N9A3722.jpeg",
  "0627" => "7N9A3747.jpeg",
  "0628" => "7N9A3831.jpeg",
  "0629" => "7N9A3845.jpeg",
  "0630" => "7N9A3848.jpeg",
  "0701" => "7N9A3853.jpeg",
  "0702" => "7N9A3858.jpeg",
  "0703" => "7N9A3864.jpeg",
  "0704" => "7N9A3870.jpeg",
  "0705" => "7N9A3872.jpeg",
  "0706" => "7N9A3888.jpeg",
  "0707" => "7N9A3898.jpeg",
  "0708" => "7N9A3901.jpeg",
  "0709" => "7N9A3909.jpeg",
  "0710" => "7N9A3922.jpeg",
  "0711" => "7N9A3930.jpeg",
  "0712" => "7N9A3937.jpeg",
  "0713" => "7N9A3939.jpeg",
  "0714" => "7N9A3942.jpeg",
  "0715" => "7N9A3947.jpeg",
  "0716" => "7N9A3951.jpeg",
  "0717" => "7N9A3956.jpeg",
  "0718" => "7N9A3958.jpeg",
  "0719" => "7N9A3962.jpeg",
  "0720" => "7N9A3965.jpeg",
  "0721" => "7N9A3971.jpeg",
  "0722" => "7N9A3975.jpeg",
  "0723" => "7N9A3981.jpeg",
  "0724" => "7N9A3985.jpeg",
  "0725" => "7N9A3994.jpeg",
  "0726" => "7N9A3999.jpeg",
  "0727" => "7N9A4011.jpeg",
  "0728" => "7N9A4014.jpeg",
  "0729" => "7N9A4020.jpeg",
  "0730" => "7N9A4026.jpeg",
  "0731" => "7N9A4028.jpeg",
  "0801" => "7N9A4033.jpeg",
  "0802" => "7N9A4036.jpeg",
  "0803" => "7N9A4041.jpeg",
  "0804" => "7N9A4045.jpeg",
  "0805" => "7N9A4047.jpeg",
  "0806" => "7N9A4051.jpeg",
  "0807" => "7N9A4054.jpeg",
  "0808" => "7N9A4055.jpeg",
  "0809" => "7N9A4058.jpeg",
  "0810" => "7N9A4063.jpeg",
  "0811" => "7N9A4064.jpeg",
  "0812" => "7N9A4069.jpeg",
  "0813" => "7N9A4075.jpeg",
  "0814" => "7N9A4081.jpeg",
  "0815" => "7N9A4115.jpeg",
  "0816" => "7N9A4118.jpeg",
  "0817" => "7N9A4121.jpeg",
  "0818" => "7N9A4133.jpeg",
  "0819" => "7N9A4143.jpeg",
  "0820" => "7N9A4151.jpeg",
  "0821" => "7N9A4155.jpeg",
  "0822" => "7N9A4158.jpeg",
  "0823" => "7N9A4167.jpeg",
  "0824" => "7N9A4170.jpeg",
  "0825" => "7N9A4175.jpeg",
  "0826" => "7N9A4179.jpeg",
  "0827" => "7N9A4182.jpeg",
  "0828" => "7N9A4185.jpeg",
  "0829" => "7N9A4543.jpeg",
  "0830" => "7N9A4552.jpeg",
  "0831" => "7N9A4554.jpeg",
  "0901" => "7N9A4558.jpeg",
  "0902" => "7N9A4560.jpeg",
  "0903" => "7N9A4565.jpeg",
  "0904" => "7N9A4568.jpeg",
  "0905" => "7N9A4572.jpeg",
  "0906" => "7N9A4576.jpeg",
  "0907" => "7N9A4684.jpeg",
  "0908" => "7N9A4686.jpeg",
  "0909" => "7N9A4690.jpeg",
  "0910" => "7N9A4693.jpeg",
  "0911" => "7N9A4695.jpeg",
  "0912" => "7N9A4702.jpeg",
  "0913" => "7N9A4704.jpeg",
  "0914" => "7N9A4721.jpeg",
  "0915" => "7N9A4733.jpeg",
  "0916" => "7N9A4738.jpeg",
  "0917" => "7N9A4740.jpeg",
  "0918" => "7N9A4746.jpeg",
  "0919" => "7N9A4833.jpeg",
  "0920" => "7N9A4847.jpeg",
  "0921" => "7N9A4853.jpeg",
  "0922" => "7N9A4857.jpeg",
  "0923" => "7N9A4862.jpeg",
  "0924" => "7N9A4874.jpeg",
  "0925" => "7N9A4896.jpeg",
  "0926" => "7N9A4902.jpeg",
  "0927" => "7N9A4914.jpeg",
  "0928" => "7N9A4918.jpeg",
  "0929" => "7N9A4919.jpeg",
  "0930" => "7N9A4930.jpeg",
  "1001" => "7N9A9314.jpeg",
  "1002" => "7N9A9324.jpeg",
  "1003" => "7N9A9330.jpeg",
  "1004" => "7N9A9337.jpeg",
  "1005" => "7N9A9347.jpeg",
  "1006" => "7N9A9358.jpeg",
  "1007" => "7N9A9396.jpeg",
  "1008" => "7N9A9433.jpeg",
  "1009" => "7N9A9437.jpeg",
  "1010" => "7N9A9441.jpeg",
  "1011" => "7N9A9444.jpeg",
  "1012" => "7N9A9451.jpeg",
  "1013" => "7N9A9457.jpeg",
  "1014" => "7N9A9459.jpeg",
  "1015" => "7N9A9465.jpeg",
  "1016" => "7N9A9467.jpeg",
  "1017" => "7N9A9470.jpeg",
  "1018" => "7N9A9482.jpeg",
  "1019" => "7N9A9494.jpeg",
  "1020" => "7N9A9620.jpeg",
  "1021" => "7N9A9626.jpeg",
  "1022" => "7N9A9642.jpeg",
  "1023" => "7N9A9645.jpeg",
  "1024" => "7N9A9649.jpeg",
  "1025" => "7N9A9653.jpeg",
  "1026" => "7N9A9659.jpeg",
  "1027" => "7N9A9664.jpeg",
  "1028" => "7N9A9667.jpeg",
  "1029" => "7N9A9673.jpeg",
  "1030" => "7N9A9741.jpeg",
  "1031" => "7N9A9746.jpeg",
  "1101" => "7N9A9780.jpeg",
  "1102" => "7N9A9847.jpeg",
  "1103" => "7N9A9859.jpeg",
  "1104" => "7N9A9875.jpeg",
  "1105" => "7N9A9886.jpeg",
  "1106" => "7N9A9913.jpeg",
  "1107" => "7N9A9923.jpeg",
  "1108" => "7N9A9969.jpeg",
  "1109" => "7N9A9973.jpeg",
  "1110" => "7N9A9977.jpeg",
  "1111" => "7N9A9980.jpeg",
  "1112" => "7N9A9986.jpeg",
  "1113" => "7N9A9991.jpeg",
  "1114" => "7N9A9997.jpeg",
  "1115" => "7N9A0066.jpeg",
  "1116" => "7N9A0239.jpeg",
  "1117" => "7N9A0247.jpeg",
  "1118" => "7N9A0372.jpeg",
  "1119" => "7N9A0377.jpeg",
  "1120" => "7N9A0382.jpeg",
  "1121" => "7N9A0387.jpeg",
  "1122" => "7N9A0390.jpeg",
  "1123" => "7N9A0394.jpeg",
  "1124" => "7N9A0403.jpeg",
  "1125" => "7N9A0410.jpeg",
  "1126" => "7N9A0422.jpeg",
  "1127" => "7N9A0426.jpeg",
  "1128" => "7N9A0539.jpeg",
  "1129" => "7N9A0544.jpeg",
  "1130" => "7N9A0546.jpeg",
  "1201" => "7N9A0550.jpeg",
  "1202" => "7N9A0556.jpeg",
  "1203" => "7N9A0560.jpeg",
  "1204" => "7N9A0585.jpeg",
  "1205" => "7N9A0588.jpeg",
  "1206" => "7N9A0591.jpeg",
  "1207" => "7N9A0594.jpeg",
  "1208" => "7N9A0599.jpeg",
  "1209" => "7N9A0615.jpeg",
  "1210" => "7N9A0622.jpeg",
  "1211" => "7N9A0632.jpeg",
  "1212" => "7N9A0638.jpeg",
  "1213" => "7N9A0648.jpeg",
  "1214" => "7N9A0665.jpeg",
  "1215" => "7N9A0678.jpeg",
  "1216" => "7N9A0686.jpeg",
  "1217" => "7N9A0694.jpeg",
  "1218" => "7N9A0702.jpeg",
  "1219" => "7N9A0705.jpeg",
  "1220" => "7N9A0720.jpeg",
  "1221" => "7N9A0725.jpeg",
  "1222" => "7N9A0729.jpeg",
  "1223" => "7N9A0742.jpeg",
  "1224" => "7N9A0766.jpeg",
  "1225" => "7N9A0768.jpeg",
  "1226" => "7N9A0777.jpeg",
  "1227" => "7N9A0783.jpeg",
  "1228" => "7N9A0785.jpeg",
  "1229" => "7N9A0789.jpeg",
  "1230" => "7N9A0795.jpeg",
  "1231" => "7N9A0802.jpeg",
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
