classdef RealtimeProcessor < handle
    % REALTIMEPROCESSOR RPcoX wrapper class
    % Wrapper for RP API, with exceptions and other enhancements
    
    % Copyright (c) 2013 Paul Sexton
    % Licensed under the BSD license. See the included LICENSE file or 
    % visit <http://opensource.org/licenses/BSD-2-Clause>.
    
    properties
        RPcoX   % TDT driver ActiveX object
        AutoTranspose = true;   % Automatically transpose to&from row vectors
    end
    
    methods
        function RP = RealtimeProcessor(RPcoX)
            if(nargin < 1)
                try
                    RP.RPcoX = actxserver('RPCO.X');
                catch comException
                    % If we caught an exception, check if the identifier is
                    % "MATLAB:COM:InvalidProgid". This most likely means
                    % the TDT drivers (or ActiveX controls) aren't
                    % installed, and we can throw a less cryptic exception.
                    % Otherwise, rethrow the original exception
                    if (strcmpi(comException.identifier, 'MATLAB:COM:InvalidProgid'))
                        error('LibTdt:COMFailure', 'Unable to link to the TDT drivers, are they installed?');
                    else
                        rethrow(comException);
                    end
                end
            else
                RP.RPcoX = RPcoX;
            end
        end
        
        % ConnectRM1
        function connectRM1(RP)
            result = RP.RPcoX.ConnectRM1('USB', 1); % Returns 1 if connection is successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'ConnectRM1 returned %d', result);
            end
        end
        
        % ConnectRX8
        function connectRX8(RP)
            result = RP.RPcoX.ConnectRX8('GB', 1); % Returns 1 if connection is successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'ConnectRX8 returned %d', result);
            end
        end
        
        % LoadCOF
        function load(RP, circuitpath)
            result = RP.RPcoX.LoadCOF(circuitpath); % Returns 1 if successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'LoadCOF returned %d', result);
            end
        end
        
        % LoadCOFsf, only 25K and 50K are supported
        function loadAt(RP, circuitpath, samplingRate)
            % Convert samplingRate to int value
            % See TDT ActiveX manual, LoadCOFsf entry, for the int values
            % for each sampling rate
            if(samplingRate == 24414)
                result = RP.RPcoX.LoadCOFsf(circuitpath, 2); % Returns 1 if successful, 0 otherwise
            elseif(samplingRate == 48828)
                result = RP.RPcoX.LoadCOFsf(circuitpath, 3); % Returns 1 if successful, 0 otherwise
            else
                error('LibTdt:InvalidParameter', 'samplingRate is %d, must be 24414 or 48828', samplingRate);
            end
            if (result ~= 1)
                error('LibTdt:CallFailure', 'LoadCOFsf returned %d', result);
            end
        end
        
        % Run
        function run(RP)
            result = RP.RPcoX.Run(); % Returns 1 if successful, 0 otherwise
            if (result ~= 1)
                throw(MException('LibTdt:CallFailure', 'Run returned %d', result));
            end
        end
        
        % Halt
        function halt(RP)
            result = RP.RPcoX.Halt(); % Returns 1 if successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'Halt returned %d', result);
            end
        end
        
        % SoftTrg
        function softTrigger(RP, trigNum)
            result = RP.RPcoX.SoftTrg(trigNum); % Returns 1 if successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'SoftTrg returned %d', result);
            end
        end
        
        % GetTagVal
        function value = getTag(RP, tagName)
            value = RP.RPcoX.GetTagVal(tagName);
        end
        
        % SetTagVal
        function setTag(RP, tagName, value)
            result = RP.RPcoX.SetTagVal(tagName, value); % Returns 1 if successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'SetTagVal returned %d', result);
            end
        end
        
        % ReadTagV
        function data = readTagV(RP, tagName, offset, length)
            data = RP.RPcoX.ReadTagV(tagName, offset, length); % Returns a row vector
            if(RP.AutoTranspose)
                data = data';
            end
        end
        
        % WriteTagV
        function writeTagV(RP, tagName, offset, data)
            if(RP.AutoTranspose)
                % check for column vector, transpose if needed
                [m,n] = size(data);
                if(m > n)
                    data = data';
                end
            end
            
            result = RP.RPcoX.WriteTagV(tagName, offset, data); % Expects a row vector
                                                                % Returns 1 if successful, 0 otherwise
            if (result ~= 1)
                error('LibTdt:CallFailure', 'WriteTagV returned %d', result);
            end
        end
    end
    
end
