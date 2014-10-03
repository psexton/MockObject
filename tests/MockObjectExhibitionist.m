classdef (Hidden = true, Sealed = true) MockObjectExhibitionist < MockObject
    %MOCKOBJECTEXHIBITIONIST Used by MockObjectTest
    %   Exposes all of MockObject's protected methods
    %   You almost certainly don't want to use this as the base class for
    %   your mocks. That's why it's sealed and hidden.
    
    % Copyright (c) 2013 Paul Sexton
    % Licensed under the BSD license. See the included LICENSE file or 
    % visit <http://opensource.org/licenses/BSD-2-Clause>.
    
    methods
        function this = MockObjectExhibitionist()
        end
        
        % Exposes MockObject.addToCallStack(call)
        function publicAddToCallStack(this, call)
            this.addToCallStack(call);
        end
    end
    
    methods (Static)
        % Exposes MockObject.nextIndex(array)
        function index = publicNextIndex(array)
            index = MockObject.nextIndex(array);
        end
    end
    
end
