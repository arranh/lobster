#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

# Lobster is an Except package designed to streamline
# common tasks over when using a remote embedded system.

package provide lobster 0.1
package require Expect

# Create the namespace
namespace eval ::lob {
    # Export commands
    namespace export begin go
}

proc ::lob::begin {hostname username password} {
	# Login to a remote SSH session.
	global spawn_id
	spawn ssh "$username@$hostname"

	expect {
	  timeout { send_user "\Unable to connect to $hostname.\n"; exit 0 }
	  eof { send_user "\nSSH connection failed for $hostname\n"; exit 0 }
	  "*assword"
	}

	send "$password\r"
	expect {
	  timeout { send_user "\nLogin failed. Password incorrect.\n"; exit 1}
	  "*\$ "
	}
}

proc ::lob::go {cd_path} {
	# Change directoru
	puts "\n\n*** Note: You must provide the fully qualified path. ***"
	puts "*** when using the ssh_cd command ***\n"
	send "cd $cd_path\r"
	expect {
	  timeout { send_user "\nCould not change dir.\n"; exit 1}
	  "*\$ "
	}
	
	send "pwd\r"	
	expect {
	  timeout { send_user "\nCould not change dir.\n"; exit 1}
	  "*\$ "
	}
}






