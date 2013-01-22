Lobster
=======

An Expect library for communicating and controlling remote embedded devices. Currently it is tailored to Linux based devices communicating over an SSH connection.

Dependencies
------------
Lobster requires the following to be installed

- Expect
- A SSH client

Commands
--------

- lob:login - logs into a remote device
- lob::reboot - reboots the device
- lob::shutdown - shuts the device down
- lob::put - put a file onto remote host.
- lob::get - get a file from the remote host.
- lob::done - closes the connection to the remote device.
