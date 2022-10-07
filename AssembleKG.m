classdef AssembleKG < handle

    properties (Access = public)
        KG
    end
    
    properties (Access = private)
        n_nod
        n_i
        Td
        Kel
        n_el
        n_dof
    end

    methods (Access = public)
        function obj = AssembleKG(cParams)
            obj.init(cParams);
        end
        function juntarKG(obj)
            obj.KG = calculateKg(obj);
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_nod = cParams.n_nod;
            obj.n_i = cParams.n_i;
            obj.Td = cParams.Td;
            obj.Kel = cParams.Kel;
            obj.n_el = cParams.n_el;
            obj.n_dof = cParams.n_dof;
        end
        function kg = calculateKg(obj)
            
            kg = zeros (obj.n_dof,obj.n_dof);
            
            for e=1:obj.n_el
                for i=1:obj.n_nod*obj.n_i
                    I=obj.Td(e,i);
                    for j=1:obj.n_nod*obj.n_i
                        J=obj.Td(e,j);
                        kg(I,J)=kg(I,J)+obj.Kel(i,j,e);
                    end
                end
            end

        end    
    end
end