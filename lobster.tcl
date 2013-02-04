#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

# Lobster is an Except package designed to streamline
# common tasks over when communicating with an embedded
# remote host.

package provide lobster 0.1
package require Expect

set lob_prompt "*\$ | *#"

# Create the namespace
namespace eval lob {
	namespace export begin go
}

# Global variable for convenience

# Simple procs to simplify
proc getHost {device} {dict get $device hostname}
proc getUser {device} {dict get $device username}
proc getPass {device} {dict get $device password}


# Create a device object. Implemented as a dictionary.
proc lob::dev {hostname username password} {
	puts $hostname
	dict set device hostname $hostname 
	dict set device username $username 
	dict set device password $password
	return $device
}

proc lob::login {device} {
	global spawn_id
	global lob_prompt
	
	# Login to a remote SSH session.	
	set user [getUser $device]
	set host [getHost $device]
	set pass [getPass $device]	
	
	spawn ssh "$user@$host"
	set host_id $spawn_id
	expect {
	  timeout { send_user "\n ### Unable to connect to $host.###\n"; return False; exit 1 }
	  eof { send_user "\n ###SSH connection failed for $user ###\n"; return False; exit 1 }
	  "RSA key" {send "yes/r"}
	  "*assword"
	}

	send "$pass\r"
	expect -re {
	  timeout { send_user "\n### Login failed. Password incorrect. ###\n"; exit 1}
	  $lob_prompt
	}
	return $host_id
}

proc lob::leave {host_id} {
	send -i $host_id "exit\r"
	expect {
		timeout {send_user "\nLogout failed.\n"; exit 1}
		"Connection to" {send_user "\n ### Logged out ### \n"}
	}
}

proc lob::go {host_id go_to_path {host_id spawn_id}} {
	global lob_prompt
	
	# Change directoru
	puts "\n\n### Note: You must provide the fully qualified path. ###"
	puts "### when using the go command ###\n"
	send -i $host_id "cd $go_to_path\r"
	expect -re {
	  timeout { send_user "\n### Could not change dir.###\n"; exit 1}
	  $lob_prompt
	}

	send "pwd\r"	
	expect {
	  timeout { send_user "\n ### Could not change dir.### \n"; exit 1}
	  "$go_to_path"
	}
}

proc lob::run {host_id command_str {check_for prompt}} {
	# Run a generic command. command_str is the command string.
	# check_for is the string (regex) Expect checks for. If it doesn't
	# find this string it fails and exits.
	puts "\n\n*** Note: There is currently little error checking ***"
	puts "*** a command may fail without you knowing. ***\n"

	send -i $host_id "$command_str\r\r"
	expect {
	  timeout { send_user "\nTimeout. Did not execute command.\n"; exit 1}
	  $check_for
	}
}

proc lob::put {device sourceFile desinationFile} {
	set user [getUser $device]
	set pass [getPass $device]
	set host [getHost $device]
	spawn scp $sourceFile $user@$host:$desinationFile
	expect {
	  timeout { send_user "\n ### Unable to connect to SCP. ###\n"; exit 1 }
	  eof { send_user "\n ###SSH connection failed over SCP. ### \n"; exit 1 }
	  "*assword"
	}

	send "$pass\r"
	expect {
	  timeout { send_user "\n ### Something failed. ###\n"; exit 1}
	  "*100% "
	}
}

proc lob::get {device sourceFile targetFile} {
	set user [getUser $device]
	set pass [getPass $device]
	set host [getHost $device]
	spawn scp  $user@$host:$sourceFile $targetFile
	expect {
	  timeout { send_user "\ ### Unable to connect to SCP. ###\n"; exit 1 }
	  eof { send_user "\n ### SSH connection failed over SCP ###\n"; exit 1 }
	  "*assword"
	}

	send "$pass\r"
	expect {
	  timeout { send_user "\n ### Something failed.###\n"; exit 1}
	  "*100% "
	}
}


