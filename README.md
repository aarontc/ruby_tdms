# RubyTDMS

(Note: The RubyTDMS gem was formerly known as simply "TDMS". The API did not change from TDMS 1.0.0
to RubyTDMS 2.0.0, but the version was bumped due to the breaking name change.)

TDMS is a binary file format for measurement data.  It was created
by National Instruments.

 - [NI TDMS File Format](http://zone.ni.com/devzone/cda/tut/p/id/3727)
 - [TDMS File Format Internal Structure](http://zone.ni.com/devzone/cda/tut/p/id/5696)

National Instruments software such as LabVIEW, DIAdem, and Measurement
Studio support reading and writing TDMS files. NI also provides a DLL
written in C for using TDMS files on Windows.

RubyTDMS provides a convenient way to work with
TDMS files on Unix-like platforms.

## Current State

This gem is nearly feature-complete for for reading the TDMS files according to the
2015 specification from National Instruments.

 - Writing TDMS files is not yet supported.

## Contributors

This gem is heavily based on the [TDMS library](http://github.com/mnaberez/tdms) created by Mike Naberezny.
