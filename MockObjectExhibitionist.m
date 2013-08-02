classdef (Hidden = true, Sealed = true) MockObjectExhibitionist < MockObject
    %MOCKOBJECTEXHIBITIONIST Used by MockObjectTest
    %   Exposes all of MockObject's protected methods
    %   You almost certainly don't want to use this as the base class for
    %   your mocks. That's why it's sealed and hidden.
    
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
