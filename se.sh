#!/usr/bin/env sh

# -l flag to specify length of encryption key, otherwise it defaults to 80 characters
# -e flag to erase the file or directory after encryption
while getopts ":l:e" opt; do
  case $opt in
    l)
      passlength="$OPTARG"
      ;;
    e)
      erase_file=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$passlength" ]; then
  passlength=80
fi

if [ -z "$1" ]; then
  echo "You must provide a file or directory path." >&2
  exit 1
fi

string="$(tr -dc '[:graph:]' </dev/urandom | head -c $passlength)"
#string="$(head -c $passlength </dev/urandom)"
file_information=$(file "$1")
new_name="$(tr -dc '[:alnum:]' </dev/urandom | head -c 10)"

create_keyfile() {

	echo "---------- Date ----------" >> ./"${new_name}"
	echo "" >> ./"${new_name}"
	date >> ./"${new_name}"
	echo "" >> ./"${new_name}"
	echo "----- Encryption Key -----" >> ./"${new_name}"
	echo "" >> ./"${new_name}"
	echo "$string" >> ./"${new_name}"
	echo "" >> ./"${new_name}"
	echo "---- File Information ----" >> ./"${new_name}"
	echo "" >> ./"${new_name}"
	echo "$file_information" >> ./"${new_name}"

}

create_keyfile;

if [ -d "$1" ]; then

	echo "" >> ./"${new_name}"
	echo "---- Files Encrypted ----" >> ./"${new_name}"
	echo "" >> ./"${new_name}"
	find "$1" -type f -printf '%p %s %TY-%Tm-%Td %TT\n' >> ./"${new_name}"
	echo "+ Compressing ""$1"" directory..."
	tar --exclude="${new_name}".tar.gz -zcvpf "${new_name}".tar.gz "$1" &&\
	echo "+ Done compression"
	echo "+ Starting Encryption on ${new_name}.tar.gz..." &&\
	echo "$string" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o "${new_name}".tar.gz.gpg "${new_name}".tar.gz && \
	echo "+ Done Encryption" &&\
	rm -rf "${new_name}".tar.gz

	if [ "$erase_file" = true ]; then
		echo "+ Erasing ""$1"" directory..."
		rm -rf "$1"
	fi

else

	echo "+ Encrypting ""$1""..."
	echo "$string" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o "${new_name}".gpg "$1" && \
	echo "+ Done Encryption"

	if [ "$erase_file" = true ]; then
		echo "+ Erasing ""$1""..."
		rm -rf "$1"
	fi
fi

# This is done to overwrite the encryption key
string="$(tr -dc '[:graph:]' </dev/urandom | head -c $passlength)"
string=""
