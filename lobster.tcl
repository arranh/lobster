#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

# Lobster is an Except package designed to streamline
# common tasks over when communicating with an embedded
# remote host.

package provide lobster 0.1
package require Expect

# Create the namespace
namespace eval lob {
	namespace export begin go
}

proc lob::login {hostname username password} {
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

proc lob::leave {} {
	send "exit\r"
	expect {
		timeout {send_user "\nLogout failed.\n"; exit 1}
		"Connection to"
	}
}

proc lob::go {go_to_path} {
	# Change directoru
	puts "\n\n*** Note: You must provide the fully qualified path. ***"
	puts "*** when using the ssh_cd command ***\n"
	send "cd $go_to_path\r"
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

proc lob::run {command_str {check_for "*\$ "}} {
	# Run a generic command. command_str is the command string.
	# check_for is the string (regex) Expect checks for. If it doesn't
	# find this string it fails and exits.
	puts "\n\n*** Note: There is currently little error checking ***"
	puts "*** a command may fail without you knowing. ***\n"

	send "$command_str\r\r"
	expect {
	  timeout { send_user "\nTimeout. Did not execute command.\n"; exit 1}
	  $check_for
	}
}

proc lob::get {} {
	
}

proc lob:put {} {
	
}

