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

Note: Windows tcl distribution doesn't support interact command

## Commands

### lob::dev
Creates a new device. Takes hostname, username and password as variables. Returns a device object. This object can be passed to other lobster commands to indicate which device you want to talk to.

	set dev_yours [lob::dev hostname username password]
	
### lob::login
Logs into a remote device over SSH. Takes the device object created by the lob::dev command. Returns a SSH connection handle, this will be passed to other commands when you want to interact with the SSH session. This allows for multiple connections to different devices.

	set yourSSH [lob::login $dev_your_device]
	

### lob::leave 
Closes the connection to the remote device. Takes the connection handle you wish to close.

	lob::leave $huclSSH
	

### lob::go
Changes directory on the remote device.

	lob::go $yourSSH /Users/username/GitHub/lobster
	

### lob::run
Use to run any command on the remote device. Takes three arguments the connection handle, the string to run and a string to match.

	lob::run $yourSSH ls "*\$ " 
	
### lob::put
Puts a file onto remote host using scp. The following command coppies the file README.md from the local device giving it a name of test.txt.

	lob::put $dev_yours README.md /Users/username/GitHub/lobster/test.txt
	
### lob::get
Gets a file from the remote host. For example the following file gets the file test.txt from the remote device and copies it to the current folder as gotit.txt

	lob::get $dev_hucl /Users/username/GitHub/lobster/test89.txt gotit.txt
	

Tips
----

During testing putting the following code into your .tclsh file will put the current directory onto tcl's path.

	set auto_path [linsert $auto_path 0 .]
	
Alternatively adding the following at the beginning of your script will add the library to the path.

	set auto_path [linsert $auto_path 0 /Users/arranholloway/GitHub/lobster] 
	