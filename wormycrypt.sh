#!/bin/fish
set help """
Send file over wormhole encrypted
wormycypt.sh <file> [output-folder]
Args:
	file: file or directory to send
	output_folder: where to put files created
		Default: pwd
"""

# Required tools 
set reqs "gpg" "tar" "sha256sum" "wormhole"
for req in $reqs
	if which $req >/dev/null
		printf "$req\n"
	else
		printf "ERROR: $req not found\n"
		return 1
	end
end

# Check for args
if [ $argv ]
	printf ""
else 
	printf "No args\n"
	return 1
end

# set files
set file $argv[1]
set output_folder (pwd)

# Check to see if positional argument 2 output_folder is set
if [ $argv[2] ]
	printf "\n"
	set output_folder $argv[2]
end

# check if help flag is present at first location
if [ $file = "-h" ]
	printf "%s\n" $help
# Check if file arg exists
else if [ $file ]
	# Check for input file
	if test -f $file
	# Set workspace to output folder
	pushd $output_folder
		printf "SUCCESS: File found processing...\n"
		set file_tar $file.tar.gz
		printf "Archiving file to $file_tar, using tar -cvzf...\n"
		# Archive file with -z (gzip)
		tar -cvzf $file_tar $file
		# Check for tar archive
		if test -f $file_tar
			printf "Archive created $(pwd)/$file\n"
			set file_tar_gpg $file_tar.gpg
			printf "Creating encrypted file...\n"
			# Create sysmetric encrypted file
			gpg -c $file_tar
			if test $file_tar_gpg
				printf "Hashing file...\n"
				# Hash the gpg file
				sha256sum $file_tar_gpg >> $file_tar_gpg.sha256sum.txt
				printf "SHA256 sum:\n\t %s\n" (cat $file.sha256sum.txt)
				printf "Sending file with wormhole: 'wormhole send $file_tar_gpg'\n"
				# Send with wormhole
				wormhole send $file_tar_gpg
			else
				# .tar.gz.gpg not detected
				printf "ERROR gpg failed $file_tar_gpg not detected\n"
			end
		else
			# .tar not detected
			printf "ERROR: Create tar failed $file_tar\n"
		end
	popd
	else
		# Input file not detected
		printf "ERROR: $file does not exist\n"
	end
else
	# Invalid Args received
	printf "ERROR: No valid Args provided \n%s\n" $help
end
