#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}

set auto_path [linsert $auto_path 0 /Users/arranholloway/GitHub/SSH] 

package require Expect
package require xSSH

xSSH::login 192.168.1.73 arranholloway k21267
#interact

