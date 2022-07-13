function [vL,vR,uR] = applyCond(n_i,n_dof,fixNod)
%--------------------------------------------------------------------------
% The function takes as inputs:

%Això és una prova

%   - Dimensions:  n_i      Number of DOFs per node
%                  n_dof    Total number of DOFs
%   - fixNod  Prescribed displacements data [Npresc x 3]
%              fixNod(k,1) - Node at which the some DOF is prescribed
%              fixNod(k,2) - DOF (direction) at which the prescription is applied
%              fixNod(k,3) - Prescribed displacement magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each displacement is prescribed.
uR = zeros(size(fixNod,1),1);
vR = zeros(size(fixNod,1),1);
vL = zeros(n_dof-size(fixNod,1),1);

aux = ones(n_dof,1);
for i=1:n_dof
    for j=1:size(fixNod,1)
        graullib=fixNod(j,2);
        posicio=2*(fixNod(j,1)-1)+graullib;
        aux(posicio,1)=fixNod(j,3);
    end
end

a=1;
b=1;
for i=1:n_dof
    if aux(i,1)==0
        vR(a,1)=i;
        a=a+1;
    else
        vL(b,1)=i;
        b=b+1;
    end
end
