classdef MockObject < handle
    %MOCKOBJECT Base class for mock objects
    %   You probably don't want to instantiate this class directly
    %   It's here so that mock obj classes can inherit from it
    
    % Copyright (c) 2013 Paul Sexton
    % Licensed under the BSD license. See the included LICENSE file or 
    % visit <http://opensource.org/licenses/BSD-2-Clause>.
    
    properties (SetAccess = protected)
        CallStack % cell array of cell arrays
        DefaultReturnValue
        ReturnValues % struct array
    end
    
    methods
        function this = MockObject()
            this.CallStack = cell(0);
            this.DefaultReturnValue = [];
            this.ReturnValues = struct('val', {}, 'name', {}, 'args', {});
        end
        
        function clearCallStack(this)
            this.CallStack = cell(0);
        end
        
        function call = mostRecentCall(this)
            % TODO: should we handle the special case of empty call stack?
            currentLength = length(this.CallStack);
            call = this.CallStack{currentLength};
        end
        
        function arguments = mostRecentArguments(this)
            % TODO: should we handle the special case of empty call stack?
            call = this.mostRecentCall();
            numArgs = length(call) - 1;
            if numArgs > 0
                arguments = call(1,2:numArgs+1);
            else
                arguments = {};
            end
        end
        
        function addReturnValueEntry(this, returnValue, methodName, methodArguments)
            % 1. No methodName or methodArguments means set the default return value
            % 2. No methodArguments means set a Name Match for that method name
            % 3. All arguments provided means set a Full Match for that call.
            if(nargin < 3)
                this.DefaultReturnValue = returnValue;
            else
                if(nargin < 4)
                    methodArguments = [];
                end
                
                index = MockObject.nextIndex(this.ReturnValues);
                this.ReturnValues(index).val = returnValue;
                this.ReturnValues(index).name = methodName;
                this.ReturnValues(index).args = methodArguments;
            end
        end
        
        function returnValue = getReturnValue(this, methodName, methodArguments)
            % Iterate through ReturnValues array
            % Keep track of 2 entries:
            % - Name match (name matches methodName, args = [])
            % - Full match (name matches methodName and args match methodArguments)
            % Afterwards, if full match was found, return that.
            % Otherwise, if name match was found, return that.
            % Otherwise, return default return value.
            
            if(nargin < 3)
                methodArguments = {};
            end
            
            fullMatch = [];
            nameMatch = [];
            
            % naive search, optimize later if needed
            % iterate through every row
            for(i = 1:length(this.ReturnValues))
                entry = this.ReturnValues(i);
                if(strcmp(entry.name, methodName))
                   % method name matches
                   if(isempty(entry.args))
                       % if entry.args == [], copy to nameMatch
                       nameMatch = entry;
                   else
                       if(isequal(entry.args, methodArguments))
                           % if entry.args ~= [] && entry.args == methodArgs, copy to fullMatch
                           fullMatch = entry;
                       end
                   end
                   % else do nothing
                end
            end
            
            if(~isempty(fullMatch))
                returnValue = fullMatch.val;
            elseif(~isempty(nameMatch))
                returnValue = nameMatch.val;
            else
                returnValue = this.DefaultReturnValue;
            end
        end
    end
    
    methods (Access = protected)
        function addToCallStack(this, call)
            index = MockObject.nextIndex(this.CallStack);
            this.CallStack{index} = call;
        end 
    end
    
    methods (Static, Access = protected)
        function index = nextIndex(array)
            % we only want to operate on vectors, not matrices.
            % if both m and n are greater than 1, throw exception
            [m, n] = size(array);
            if(m > 1 && n > 1)
                throw(MException('mockobject:DimensionMismatch', 'm=%d, n=%d', m, n));
            end
            
            currentLength = length(array);
            index = currentLength + 1;
        end
    end
    
end
