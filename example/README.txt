MockObject Example
==================

This is the actual first use case I developed MockObject for:

RPCO.X is an ActiveX control for interfacing with hardware devices from Tucker-Davis Technologies.

RealtimeProcessor is a Matlab class I wrote to make it easier to communicate with TDT devices. It checks status codes returned by the device and converts non-successful ones into exceptions. It handles transposing row vectors and column vectors (the devices will only accept one of them, and I can never remember which it is.)

MockRPcoX is a subclass of MockObject that I use for testing.

RealtimeProcessorTest contains xUnit-style tests for the RealtimeProcessor class, using MockRPCoX to simulate a device.


Last Updated:  
Paul Sexton  
2013-08-03  