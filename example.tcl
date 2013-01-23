#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

set auto_path [linsert $auto_path 0 /Users/arranholloway/GitHub/lobster] 

set timeout 10

# Requires the lobster package
package require Expect
package require lobster

#exp_internal 1

# Logs in to remote host
lob::login 192.168.1.78 arranholloway k21267

# Changes directory on remote host
lob::go /Users/arranholloway/GitHub/lobster	

# Run any command. Note: there is minimal error checking.
lob::run ls
lob::run q

# Logs out of remote host
lob::leave



