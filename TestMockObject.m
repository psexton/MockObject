classdef TestMockObject < TestCase
    %TESTMOCKOBJECT Unit tests for the MockObject class
    %
    % MockObject is made up of two independent parts:
    %   1) Call stack
    %   2) Return value lookup
    %
    %   Methods for (1)
    %       clearCallStack()
    %       call = mostRecentCall()
    %       arguments = mostRecentArguments()
    %       [protected] addToCallStack(call)
    %
    %   Methods for (2)
    %       addReturnValueEntry(returnValue, methodName, methodArguments)
    %       returnValue = getReturnValue(methodName, methodArguments)
    %
    %   Other methods:
    %       ctr()
    %       [static, protected] index = nextIndex(array)

    % Copyright (c) 2013 Paul Sexton
    % Licensed under the BSD license. See the included LICENSE file or 
    % visit <http://opensource.org/licenses/BSD-2-Clause>.

    properties
        mock;
    end
    
    methods
        function this = TestMockObject(name)
            this = this@TestCase(name);
        end
        
        function setUp(this)
            % Create instance
            this.mock = MockObject();
        end
        
        %------------------------------
        % constructor
        function testCtr(this)
            % call stack is empty cell array
            % default return value is empty matrix
            % return value array is empty struct with field names {val, name, args}
            assertEqual({}, this.mock.CallStack);
            assertEqual([], this.mock.DefaultReturnValue);
            assertEqual(struct('val', {}, 'name', {}, 'args', {}), this.mock.ReturnValues);
        end
        
        %------------------------------
        % [static, protected] nextIndex
        function testNextIndex(this)
            % returns size of array + 1
            % create test data
            vector0 = [];
            cell0 = {};
            vector3 = [2 3 4];
            cell2 = {'methodName', 'methodArg'};
            cell3 = {'bar', [25 31 6], {'a', 'b', 'c'}};
            % check each of them
            assertEqual(1, MockObjectExhibitionist.publicNextIndex(vector0));
            assertEqual(1, MockObjectExhibitionist.publicNextIndex(cell0));
            assertEqual(4, MockObjectExhibitionist.publicNextIndex(vector3));
            assertEqual(3, MockObjectExhibitionist.publicNextIndex(cell2));
            assertEqual(4, MockObjectExhibitionist.publicNextIndex(cell3));
            % check that passing in a matrix throws an exception
            matrix33 = [1 2 3; 4 5 6; 7 8 9];
            f = @() MockObjectExhibitionist.publicNextIndex(matrix33);
            assertExceptionThrown(f, 'mockobject:DimensionMismatch');
        end
        
        %------------------------------------------------------------
        % CALL STACK SECTION
        %------------------------------------------------------------
        
        %------------------------------
        % [protected] addToCallStack
        function testAddToCallStack(this)
            % add a call, check that it mirrors expected behavior. repeat.
            call1 = {'methodName', 'methodArg'};
            call2 = {'foo', 24, 36};
            call3 = {'bar', [25 31 6], {'a', 'b', 'c'}};
            % Use MockObjectExhibitionist so we can directly call addToCallStack
            moe = MockObjectExhibitionist();
            expectedCallStack = {};
            nextIndex = @(x) MockObjectExhibitionist.publicNextIndex(x); % convenience handle
            assertEqual(expectedCallStack, moe.CallStack);
            % add call #1
            moe.publicAddToCallStack(call1);
            expectedCallStack{nextIndex(expectedCallStack)} = call1;
            assertEqual(expectedCallStack, moe.CallStack);
            % add call #2
            moe.publicAddToCallStack(call2);
            expectedCallStack{nextIndex(expectedCallStack)} = call2;
            assertEqual(expectedCallStack, moe.CallStack);
            % add call #3
            moe.publicAddToCallStack(call3);
            expectedCallStack{nextIndex(expectedCallStack)} = call3;
            assertEqual(expectedCallStack, moe.CallStack);
        end
        
        
        %------------------------------
        % clearCallStack
        function testClearCallStack(this)
            % call stack should be initially empty; add a call, test that call stack
            % is size 1. call clearCallStack, test that call stack is empty
            moe = MockObjectExhibitionist();
            moe.publicAddToCallStack({'methodName', 'methodArg'});
            assertEqual(1, length(moe.CallStack));
            moe.clearCallStack();
            assertEqual(0, length(moe.CallStack));
            % test that calling clearCallStack on an empty stack doesn't break anything
            moe.clearCallStack();
        end
        
        %------------------------------
        % mostRecentCall
        % 3 cases to test: No calls, 1 call, >1 calls
        function testMostRecentCall(this)
            % empty call stack - we don't do anything special, so should throw a matlab
            % exception
            this.mock.clearCallStack()
            f = @() this.mock.mostRecentCall();
            assertExceptionThrown(f, 'MATLAB:badsubscript');
            % 1 entry - should return that
            moe = MockObjectExhibitionist();
            call1 = {'method1', 'arg1'};
            moe.publicAddToCallStack(call1);
            assertEqual(call1, moe.mostRecentCall());
            % 2 entries - should return newest one
            call2 = {'method2', 'arg2'};
            moe.publicAddToCallStack(call2);
            assertEqual(call2, moe.mostRecentCall());
        end
        
        %------------------------------
        % mostRecentArguments
        % Assume call stack is non-empty
        % Two cases: In most recent call, 0, >0 arguments
        function testMostRecentArguments(this)
            % 0 arguments - should return empty cell array
            moe = MockObjectExhibitionist();
            call1 = {'method1'};
            moe.publicAddToCallStack(call1);
            assertEqual({}, moe.mostRecentArguments());
            % >0 arguments - should return cell array
            call2 = {'method2', 'arg2'};
            moe.publicAddToCallStack(call2);
            assertEqual({'arg2'}, moe.mostRecentArguments());
        end
        
        %------------------------------------------------------------
        % RETURN VALUE LOOKUP SECTION
        %------------------------------------------------------------
        
        %------------------------------
        % addReturnValueEntry
        function testAddReturnValueEntry(this)
            % Adding a default entry
            assertEqual([], this.mock.DefaultReturnValue);
            defaultReturnValue = 42;
            this.mock.addReturnValueEntry(defaultReturnValue);
            assertEqual(defaultReturnValue, this.mock.DefaultReturnValue);
            assertEqual(struct('val', {}, 'name', {}, 'args', {}), this.mock.ReturnValues);
            % Adding a Name Match entry
            entry1 = struct('val', 43, 'name', 'foo', 'args', []);
            this.mock.addReturnValueEntry(entry1.val, entry1.name, entry1.args);
            assertEqual(defaultReturnValue, this.mock.DefaultReturnValue);
            assertEqual(entry1, this.mock.ReturnValues(1));
            % Adding a Full Match entry
            entry2 = struct('val', 43, 'name', 'foo', 'args', {{'my', 'very', 37}});
            this.mock.addReturnValueEntry(entry2.val, entry2.name, entry2.args);
            assertEqual(defaultReturnValue, this.mock.DefaultReturnValue);
            assertEqual(entry2, this.mock.ReturnValues(2));
        end
        
        % getReturnValue cases to add:
        % 1) Full match found
        % 2) Full match found (name match also available)
        % 3) Full match found (matching name with non-matching args also available)
        % 4) Name match found
        % 5) Name match found (non-matching name also available)
        % 6) Name match found (matching name with non-matching args also available)
        % 7) Default match found
        % 8) Default match found (non-matching name also available)
        % 9) Default match found (non-matching name with args also available)
        
        % Six different testGetReturnValue functions, for the six possible states
        % of the lookup table:
        %   1) []           Empty
        %   2) A            Name only entry
        %   3) A(1)         Name+args entry
        %   4) A, A(1)      Name only and Name+args entries
        %   5) A(1), A(2)   Two different name+args entries with same name
        %   6) A, B         Two different name only entries
        %   7) A(1), B      Two different Name+args and name only entries
        %
        % In each of these test functions, there are up to 6 possible input arguments:
        %   1) A
        %   2) A(1)
        %   3) A(2)
        %   4) B
        %   5) B(1)
        %   6) C
        
        %------------------------------
        % getReturnValue (table = [])
        function testGetReturnValue_Empty(this)
            % With an empty lookup table, we only need to test two cases:
            % name with no args, and name + args
            defaultReturnValue = 17;
            this.mock.addReturnValueEntry(defaultReturnValue);
            assertEqual(defaultReturnValue, this.mock.getReturnValue('someMethod'));
            assertEqual(defaultReturnValue, this.mock.getReturnValue('someMethod', {1}));
        end
        
        %------------------------------
        % getReturnValue (table = A)
        function testGetReturnValue_A(this)
            % Test that A and A(1) return A's value, and that B and B(1) return the default
            defaultReturnValue = 17;
            aReturnValue = 'apple';
            aMethodName = 'methodA';
            bMethodName = 'methodB';
            methodArgs1 = {1};
            this.mock.addReturnValueEntry(defaultReturnValue);
            this.mock.addReturnValueEntry(aReturnValue, aMethodName);
            assertEqual(aReturnValue, this.mock.getReturnValue(aMethodName));
            assertEqual(aReturnValue, this.mock.getReturnValue(aMethodName, methodArgs1));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName, methodArgs1));
        end
        
        %------------------------------
        % getReturnValue (table = A(1))
        function testGetReturnValue_A1(this)
            % Test that A(1) return A1's value, and that A, B and B(1) return the default
            defaultReturnValue = 17;
            a1ReturnValue = 'argue';
            aMethodName = 'methodA';
            bMethodName = 'methodB';
            methodArgs1 = {1};
            this.mock.addReturnValueEntry(defaultReturnValue);
            this.mock.addReturnValueEntry(a1ReturnValue, aMethodName, methodArgs1);
            assertEqual(a1ReturnValue, this.mock.getReturnValue(aMethodName, methodArgs1));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(aMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName, methodArgs1));
        end
        
        %------------------------------
        % getReturnValue (table = A, A(1))
        function testGetReturnValue_AA1(this)
            % Test that A and A(1) return their respective values, and that B and B(1)
            % return the default
            defaultReturnValue = 17;
            aReturnValue = 'apple';
            a1ReturnValue = 'argue';
            aMethodName = 'methodA';
            bMethodName = 'methodB';
            methodArgs1 = {1};
            this.mock.addReturnValueEntry(defaultReturnValue);
            this.mock.addReturnValueEntry(aReturnValue, aMethodName);
            this.mock.addReturnValueEntry(a1ReturnValue, aMethodName, methodArgs1);
            assertEqual(aReturnValue, this.mock.getReturnValue(aMethodName));
            assertEqual(a1ReturnValue, this.mock.getReturnValue(aMethodName, methodArgs1));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName, methodArgs1));
        end
        
        %------------------------------
        % getReturnValue (table = A(1), A(2))
        function testGetReturnValue_A1A2(this)
            % Test that A(1) and A(2) return their respective values, and that A, B and B(1)
            % return the default
            defaultReturnValue = 17;
            a1ReturnValue = 'argue';
            a2ReturnValue = 'adapt';
            aMethodName = 'methodA';
            bMethodName = 'methodB';
            methodArgs1 = {1};
            methodArgs2 = {2};
            this.mock.addReturnValueEntry(defaultReturnValue);
            this.mock.addReturnValueEntry(a1ReturnValue, aMethodName, methodArgs1);
            this.mock.addReturnValueEntry(a2ReturnValue, aMethodName, methodArgs2);
            assertEqual(a1ReturnValue, this.mock.getReturnValue(aMethodName, methodArgs1));
            assertEqual(a2ReturnValue, this.mock.getReturnValue(aMethodName, methodArgs2));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(aMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(bMethodName, methodArgs1));
        end
        
        %------------------------------
        % getReturnValue (table = A, B)
        function testGetReturnValue_AB(this)
            % Test that A and A(1) return A's value, that B and B(1) return B's value,
            % and that C returns the default.
            defaultReturnValue = 17;
            aReturnValue = 'apple';
            bReturnValue = 'bingo';
            aMethodName = 'methodA';
            bMethodName = 'methodB';
            cMethodName = 'methodC';
            methodArgs1 = {1};
            methodArgs2 = {2};
            this.mock.addReturnValueEntry(defaultReturnValue);
            this.mock.addReturnValueEntry(aReturnValue, aMethodName);
            this.mock.addReturnValueEntry(bReturnValue, bMethodName);
            assertEqual(aReturnValue, this.mock.getReturnValue(aMethodName));
            assertEqual(aReturnValue, this.mock.getReturnValue(aMethodName, methodArgs1));
            assertEqual(bReturnValue, this.mock.getReturnValue(bMethodName));
            assertEqual(bReturnValue, this.mock.getReturnValue(bMethodName, methodArgs1));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(cMethodName));
        end
        
        %------------------------------
        % getReturnValue (table = A(1), B)
        function testGetReturnValue_A1B(this)
            % Test that A(1), B and B(1) return their table entries, and that A, A(2)
            % and C return the default
            defaultReturnValue = 17;
            a1ReturnValue = 'argue';
            bReturnValue = 'bingo';
            aMethodName = 'methodA';
            bMethodName = 'methodB';
            cMethodName = 'methodC';
            methodArgs1 = {1};
            methodArgs2 = {2};
            this.mock.addReturnValueEntry(defaultReturnValue);
            this.mock.addReturnValueEntry(a1ReturnValue, aMethodName, methodArgs1);
            this.mock.addReturnValueEntry(bReturnValue, bMethodName);
            assertEqual(a1ReturnValue, this.mock.getReturnValue(aMethodName, methodArgs1));
            assertEqual(bReturnValue, this.mock.getReturnValue(bMethodName));
            assertEqual(bReturnValue, this.mock.getReturnValue(bMethodName, methodArgs1));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(aMethodName));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(aMethodName, methodArgs2));
            assertEqual(defaultReturnValue, this.mock.getReturnValue(cMethodName));
        end
    end
    
end
