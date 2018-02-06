

param(
	[array] $files
)
foreach($archive in $files) {
	write-output "Unziping $archive"
	start-process winzip64 "-e $archive"
}
