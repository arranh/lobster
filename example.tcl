#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

set auto_path [linsert $auto_path 0 /Users/arranholloway/GitHub/lobster] 

# Requires the lobster package
package require lobster
package require Expect

# Sets timeout to 1. Useful when talking to things on local networks
set timeout 1


# Creates a device
set dev_hucl [lob::dev 192.168.1.100 arranholloway k21267]

# Logs in to remote host
set huclSSH [lob::login $dev_hucl]

# Check that the login has worked, try another loging if it hasn't worked
#if {$huclSSH == False} {
#	set huclSSH [lob::login 192.168.1.78 arranholloway k21267]
#}

# Check that the login has worked
if {$huclSSH == False} {
	puts "Sorry wasn't possible to connect - now exiting"
	exit
}

# Changes directory on remote host
lob::go $huclSSH /Users/arranholloway/GitHub/lobster

# Run any command. Note: there is minimal error checking currently only support globs
lob::run $huclSSH ls "*\$ " 

# Put a file on the remote host
lob::put $dev_hucl README.md /Users/arranholloway/GitHub/lobster/test89.txt

# Get a file from the remote host
lob::get $dev_hucl /Users/arranholloway/GitHub/lobster/test89.txt test_get.txt

# Interact with process, return to script after entering +++
puts "### Entering interactive mode type +++ to exit"
interact "+++" return

# Logs out of remote host. You should make sure you do this for
# each connection created.
lob::leave $huclSSH

