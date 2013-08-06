classdef MockRPcoX < MockObject
    %MOCKRPCOX Mocked version of the RPcoX COM/ActiveX object
    %   Note that the method names start with an uppercase letter.
    %   This is to maintain API compatibility with the "real"
    %   RPCO.X ActiveX objects.
    
    % Copyright (c) 2013 Paul Sexton
    % Licensed under the BSD license. See the included LICENSE file or 
    % visit <http://opensource.org/licenses/BSD-2-Clause>.
    
    properties
        ReturnSuccess
    end
    
    methods
        function RP = MockRPcoX()
            RP.ReturnSuccess = true;
        end
        
        function result = ConnectRM1(RP, interface, devNum)
            RP.addToCallStack({'ConnectRM1', interface, devNum});
            result = RP.queryMockObj('ConnectRM1', {interface, devNum});
        end
        
        function result = ConnectRX8(RP, interface, devNum)
            RP.addToCallStack({'ConnectRX8', interface, devNum});
            result = RP.queryMockObj('ConnectRX8', {interface, devNum});
        end
        
        function result = LoadCOF(RP, fileName)
            RP.addToCallStack({'LoadCOF', fileName});
            result = RP.queryMockObj('LoadCOF', {fileName});
        end
        
        function result = LoadCOFsf(RP, fileName, sampleFrequency)
            RP.addToCallStack({'LoadCOFsf', fileName, sampleFrequency});
            result = RP.queryMockObj('LoadCOFsf', {fileName, sampleFrequency});
        end
        
        function result = Run(RP)
            RP.addToCallStack({'Run'});
            result = RP.queryMockObj('Run', {});
        end
        
        function result = Halt(RP)
            RP.addToCallStack({'Halt'});
            result = RP.queryMockObj('Halt', {});
        end
        
        function result = SoftTrg(RP, trgBitn)
            RP.addToCallStack({'SoftTrg', trgBitn});
            result = RP.queryMockObj('SoftTrg', {trgBitn});
        end
        
        function result = SetTagVal(RP, name, val)
            RP.addToCallStack({'SetTagVal', name, val});
            result = RP.queryMockObj('SetTagVal', {name, val});
        end
        
        function result = WriteTagV(RP, name, nOS, buffer)
            RP.addToCallStack({'WriteTagV', name, nOS, buffer});
            result = RP.queryMockObj('WriteTagV', {name, nOS, buffer});
        end
        
        function value = GetTagVal(RP, name)
            RP.addToCallStack({'GetTagVal', name});
            value = RP.queryMockObj('GetTagVal', {name});
        end
        
        function data = ReadTagV(RP, name, nOS, nWords)
            RP.addToCallStack({'ReadTagV', name, nOS, nWords});
            data = RP.queryMockObj('ReadTagV', {name, nOS, nWords});
        end
    end
    
    methods (Access = private)
        function result = queryMockObj(RP, methodName, methodArgs)
            if(RP.ReturnSuccess)
                RP.DefaultReturnValue = 1;
            else
                RP.DefaultReturnValue = 0;
            end
            result = RP.getReturnValue(methodName, methodArgs);
        end
    end
    
end
