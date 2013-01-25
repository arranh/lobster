# Lobster


An Expect library for communicating and controlling remote embedded devices. Currently it is tailored to Linux based devices communicating over an SSH connection.

## Dependencies
To use lobster you should make sure the following are installed:

- Expect 
- An SSH client

### Windows installation
1. Download and install ActiveTcl from http://www.activestate.com/activetcl/downloads
2. Install the Expect extension through teacup
	tecup install Expect
3. Download and install openSSH for windows from http://sshwindows.sourceforge.net/download/

## Commands

### Implemented
- lob:login - begins a session with the remote device
- lob::leave - closes the connection to the remote device.
- lob:go - goes to a location on the remote device
- lob::put - put a file onto remote host.
- lob::get - get a file from the remote host.

### To do
- lob::reboot - reboots the device
- lob::shutdown - shuts the device down


Tips
----

During testing putting the following code into your .tclsh file will put the current directory onto tcl's path.

	set auto_path [linsert $auto_path 0 .]