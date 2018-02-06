#!/usr/bin/perl


$download_count = 0;
$pagenum = 1;
$maxnum = 5;
$publisher = "universities-press-india-private-limited";
$search = "distributed+computing";
$category = "computers-internet";
while ($pagenum <= $maxnum) {
	
#	$wget = "wget -qO- http://www.foxebook.net/page/$pagenum/";
#	$wget = "wget -qO- http://www.foxebook.net/new-release/page/$pagenum/";
#	$wget = "wget -qO- http://www.foxebook.net/publisher/$publisher/page/$pagenum/";
#	$wget = "wget -qO- http://www.foxebook.net/search/$search/page/$pagenum/";
	$wget = "wget -qO- http://www.foxebook.net/category/$category/page/$pagenum/";

	$page = `$wget`;
		
	while ($page =~ m/button\"\shref=\"\/([a-z0-9A-Z\-]+)\//g) {
		
		$book = $1;
		
		$wget = "wget -qO- http://www.foxebook.net/$book";
		# print "$wget\n";
		$file_page = `$wget`;
		if ($file_page =~ m/(www[0-9]+\.zippyshare\.com)\/v\/([a-zA-Z0-9]+)\/file.html/g) {
			
			$site = $1;
			$id = $2;
			$wget = "wget -qO- $site/v/$id/file.html";
			$file = `$wget`;
			print "$wget\n";
			while ($file =~ m/href\s\=\s\"\/d\/$id\/"\s\+\s\(([0-9]+)\s\%\s([0-9]+)\s\+\s([0-9]+)\s\%\s([0-9]+)\)\s\+\s\"\/([a-zA-Z0-9\-\.]+)/g) {
					$download_count++;
					$num1 = $1 % $2;
					$num2 = $3 % $4;
					$num = $num1 + $num2;
					$file = $5;
					$wget = "wget -nc $site/d/$id/$num/$file";
					system("clear");
					print "\nDownloading File Number: $download_count\n";
					print "On page: $pagenum\n\n";
					system($wget);
				
			}
		}
		
	}
	
	$pagenum++
}
