function Td = connectDOFs(n_el,n_nod,n_i,Tn)
%--------------------------------------------------------------------------
% The function takes as inputs:
% prova
%   - Dimensions:  n_el     Total number of elements
%                  n_nod    Number of nodes per element
%                  n_i      Number of DOFs per node
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%--------------------------------------------------------------------------
% It must provide as output:
%segona prova
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering.

for i=1:n_el
    a=1;
    for j=1:n_nod
        for k=1:n_i
            Td(i,a)= 2*(Tn(i,j)-1) + k; 
            a = a+1;
        end
    end
end