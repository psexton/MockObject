MockObject
==========

A mock object library for MATLAB.

Overview
--------

I initially wrote MockObject to help me unit test code that connected to hardware devices using COM objects. By swapping in a mock for the actual COM object, I could could simulate any device behavior I wanted.

I've since used it to mock HTTP sessions as well, and it's probably useful wherever you want to mock out Something Big.

Features
--------

The MockObject class has two main features:
* It maintains a lookup table of function return values: for any function, for a specific function, or for a specific function with specific arguments
* It maintains a list of what methods were called, along with the arguments used.

How to Use
----------

1. Create a subclass of MockObject.(Let's call it MockFoo.) Add functions to this subclass that match the signatures of the functions in the class you're mocking(RealFoo). Each function in MockFoo will make a call to addToCallStack to record that it's been called, and a call to getReturnValue to find out what it should return.
2. At runtime, create an instance of MockFoo. Call addReturnValueEntry to add values to the return value lookup table.
3. Use MockFoo in place of RealFoo.
4. Inspect the MockFoo.CallStack property to see what methods were called.

Examples
--------

See the example subdirectory for an example of how this would work.

Bug Reports And Contributions
-----------------------------

The code for this project is available on GitHub at https://github.com/psexton/MockObject.

To file a bug report or feature request, go to https://github.com/psexton/MockObject/issues/new.

Licensing
---------

Licensed under the [BSD 2-Clause license](http://opensource.org/licenses/BSD-2-Clause). See the LICENSE file in this directory.
