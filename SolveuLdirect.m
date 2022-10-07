classdef SolveuLdirect < handle

    properties (Access = public)
        uL
    end
    
    properties (Access = private)
        LHS
        RHS
    end

    methods (Access = public)
        function obj = SolveuLdirect(cParams)
            obj.init(cParams);
        end
        function obteniruL(obj)
            obj.uL = calculateuL(obj);
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.LHS = cParams.LHS;
            obj.RHS = cParams.RHS;
        end
        function ul = calculateuL(obj)
            ul = inv(obj.LHS)*(obj.RHS);
        end    
    end
end