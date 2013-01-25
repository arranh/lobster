#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

set auto_path [linsert $auto_path 0 /Users/arranholloway/GitHub/lobster] 

set timeout 30

# Requires the lobster package
package require lobster

# Logs in to remote host
set huclSSH [lob::login 192.168.1.78 arranholloway k21267]

# Changes directory on remote host
lob::go $huclSSH /Users/arranholloway/GitHub/lobster

# Run any command. Note: there is minimal error checking.
lob::run $huclSSH ls "*\$ " 

# Put a file on the remote host
lob::put 192.168.1.78 arranholloway k21267 README.md /Users/arranholloway/GitHub/lobster/test89.txt

# Get a file from the remote host
lob::get 192.168.1.78 arranholloway k21267 /Users/arranholloway/GitHub/lobster/test89.txt test_get.txt

# Logs out of remote host. You should make sure you do this for
# each connection created.
lob::leave $huclSSH

