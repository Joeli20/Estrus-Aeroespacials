function [u,R,LHS,RHS] = solveSys(vL,vR,uR,KG,Fext,F0)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% It must provide as output:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

KLL = KG(vL,vL);
KLR = KG(vL,vR);
KRL = KG(vR,vL);
KRR = KG(vR,vR);
FextL = Fext(vL,1);
FextR = Fext(vR,1);
F0L = F0(vL,1);
F0R = F0(vR,1);

LHS = KLL;
RHS = FextL-KLR*uR+F0L;

st.LHS = LHS;
st.RHS = RHS;

disp 'Enter 1 for a Direct Solver';
disp 'Enter 2 for an Iterative Solver';
n = input('Choose your Solver type: ');

switch n

    case 1

        calculuL = SolveuLdirect(st);

    case 2
        
        calculuL = SolveuLiterative(st);

end

calculuL.obteniruL;
uL = calculuL.uL;

% old -> uL = inv(LHS)*(RHS);
R = KRR*uR + KRL*uL - FextR - F0R;

u(vL,1)=uL;
u(vR,1)=uR;


end