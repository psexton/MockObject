classdef TestRealtimeProcessor < TestCase
    %TESTREALTIMEPROCESSOR Unit tests for RealtimeProcessor class
    
    properties
        rp;
    end
    
    methods
        function this = TestRealtimeProcessor(name)
            this = this@TestCase(name);
        end
        
        function setUp(this)
            % Create instance
            mockRPcoX = MockRPcoX();
            this.rp = RealtimeProcessor(mockRPcoX);
        end
        
        %------------------------------
        % connectRM1
        
        % First test success behavior
        function testConnectRM1(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            this.rp.connectRM1();
            assertEqual({'USB', 1}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testConnectRM1_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.connectRM1();
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end
        
        %------------------------------
        % connectRX8
        
        % First test success behavior
        function testConnectRX8(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            this.rp.connectRX8();
            assertEqual({'GB', 1}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testConnectRX8_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.connectRX8();
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end

        %------------------------------
        % load
        
        % First test success behavior
        function testLoad(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            circuitFile = 'C:\foo\bar\circuit.rcx';
            this.rp.load(circuitFile);
            assertEqual({circuitFile}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testLoad_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.load('C:\foo\bar\circuit.rcx');
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end
        
        %------------------------------
        % loadAt
        
        % Test success behavior (24414)
        function testLoadAt_24(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            circuitFile = 'C:\foo\bar\circuit.rcx';
            samplingRate = 24414;
            this.rp.loadAt(circuitFile, samplingRate);
            assertEqual({circuitFile, 2}, mockRP.mostRecentArguments);
        end
        
        % Test success behavior (48828)
        function testLoadAt_48(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            circuitFile = 'C:\foo\bar\circuit.rcx';
            samplingRate = 48828;
            this.rp.loadAt(circuitFile, samplingRate);
            assertEqual({circuitFile, 3}, mockRP.mostRecentArguments);
        end
        
        % Test failure behavior (invalid Fs)
        function testLoadAt_96(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            f = @() this.rp.loadAt('C:\foo\bar\circuit.rcx', 97656);
            assertExceptionThrown(f, 'LibTdt:InvalidParameter');
        end
        
        % Test failure behavior (device failure)
        function testLoadAt_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.loadAt('C:\foo\bar\circuit.rcx', 24414);
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end
        
        %------------------------------
        % run
        
        % First test success behavior
        function testRun(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            this.rp.run();
            assertEqual({}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testRun_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.run();
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end

        %------------------------------
        % halt
        
        % First test success behavior
        function testHalt(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            this.rp.halt();
            assertEqual({}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testHalt_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.halt();
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end

        %------------------------------
        % softTrigger
        
        % First test success behavior
        function testSoftTrigger(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            softTrg = 1;
            this.rp.softTrigger(softTrg);
            assertEqual({softTrg}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testSoftTrigger_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.softTrigger(1);
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end

        %------------------------------
        % getTag
        
        function testGetTag(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            returnValue = 42;
            tagName = 'ImATag';
            mockRP.addReturnValueEntry(returnValue, 'GetTagVal', {tagName});
            val = this.rp.getTag(tagName);
            assertEqual({tagName}, mockRP.mostRecentArguments);
            assertEqual(returnValue, val);
        end
        
        % There's no success/failure error code, so no 2nd test
        
        %------------------------------
        % setTag
        
        % First test success behavior
        function testSetTag(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            tagName = 'ImATag';
            tagVal = 42;
            this.rp.setTag(tagName, tagVal);
            assertEqual({tagName, tagVal}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testSetTag_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.setTag('ImATag', 42);
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end

        %------------------------------
        % readTagV
        
        function testReadTagV(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            tagName = 'ImATag';
            offset = 4;
            length = 32;
            returnValue = ones(1, length);
            mockRP.addReturnValueEntry(returnValue, 'ReadTagV', {tagName, offset, length});
            data = this.rp.readTagV(tagName, offset, length);
            assertEqual({tagName, offset, length}, mockRP.mostRecentArguments);
            % When AutoTranspose is on (default), RealtimeProcessor should return a
            % column vector
            assertEqual(returnValue', data);
            % When AutoTranspose is off, RealtimeProcessor should return a row vector
            this.rp.AutoTranspose = false;
            data = this.rp.readTagV(tagName, offset, length);
            assertEqual(returnValue, data);
        end
        
        % There's no success/failure error code, so no 2nd test
        
        %------------------------------
        % writeTagV
        
        % First test success behavior
        function testWriteTagV(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            tagName = 'ImATag';
            offset = 4;
            data = ones(1, 37);
            this.rp.writeTagV(tagName, offset, data);
            assertEqual({tagName, offset, data}, mockRP.mostRecentArguments);
        end
        
        % Test that AutoTranspose is working properly
        function testWriteTagV_AutoTranspose(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = true;
            tagName = 'ImATag';
            offset = 4;
            data = ones(37, 1); % column vector
            % When AutoTranspose is on (default), mockRP should get a row vector
            this.rp.writeTagV(tagName, offset, data);
            assertEqual({tagName, offset, data'}, mockRP.mostRecentArguments);
            % When AutoTranspose is off, mockRP should get a column vector
            this.rp.AutoTranspose = false;
            this.rp.writeTagV(tagName, offset, data);
            assertEqual({tagName, offset, data}, mockRP.mostRecentArguments);
        end
        
        % Now test failure behavior
        function testWriteTagV_Failure(this)
            mockRP = this.rp.RPcoX;
            mockRP.ReturnSuccess = false;
            f = @() this.rp.writeTagV('ImATag', 4, ones(1,37));
            assertExceptionThrown(f, 'LibTdt:CallFailure');
        end

    end
    
end
