%-------------------------------------------------------------------------%
% ASSIGNMENT 01 - Part B1 + B2
%-------------------------------------------------------------------------%

% Date:21/02/2022
% Author/s: Gerard Toset Alonso
%           Joel Campo Moyà

clear;
close all;

%% INPUT DATA

F = 0; %N
Young = 75000 ; %MPa
Area = 120 ;    %mm2
thermal_coeff = 0.0000023 ; %K^-1
Inertia = 1400; %mm4


%% PREPROCESS

% Nodal coordinates matrix creation
%  x(a,j) = coordinate of node a in the dimension j
x = [   0   0 ;
        0.5 0.2;
        1   0.4;
        1.5 0.6;
        0   0.5;
        0.5 0.6;
        1   0.7;
        1.5 0.8;
];

% Connectivities matrix ceation
%  Tn(e,a) = global nodal number associated to node a of element e
Tn = [	1   2;
        2   3;
        3   4;
        5   6;
        6   7;
        7   8;
        1   5;
        1   6;
        2   5;
        2   6;
        2   7;
        3   6;
        3   7;
        3   8;
        4   7;
        4   8;
];

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [   2   2   3*F;
            3   2   2*F;
            4   2   F;
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [  1   1   0;
            1   2   0;
            5   1   0;
            5   2   0;
];

% Material data
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  --more columns can be added for additional material properties--
mat = [% Young M.   Section A.   thermal_coeff   Inertia
         Young,   Area,      thermal_coeff,     Inertia;  % Material (1)
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [    1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1;
            1; 
];

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tn,1);            % Total number of elements
n_nod = size(Tn,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 

% Computation of the DOFs connectivities
Td = connectDOFs(n_el,n_nod,n_i,Tn);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d,n_nod,n_i,n_el,x,Tn,mat,Tmat);

% Global matrix assembly
KG = assemblyKG(n_el,n_nod,n_i,n_el_dof,n_dof,Td,Kel);

% Global force vector assembly
Fext = computeF(n_i,n_dof,Fdata);

%---- TEMPERATURE ----

deltaT = -5;
for e= 1:n_el
    x1e = x(Tn(e,1),1);
    y1e = x(Tn(e,1),2);
    x2e = x(Tn(e,2),1);
    y2e = x(Tn(e,2),2);
    
    le = sqrt(((x2e-x1e)^2)+((y2e-y1e)^2));
    se = (y2e-y1e)/le;
    ce = (x2e-x1e)/le;
    
    Re = [  ce  se	0	0;
            -se	ce	0	0;
            0   0   ce	se;
            0   0   -se	ce;
    ];
    eps0=mat(Tmat(1),3)*deltaT;
    F0e=eps0*mat(Tmat(1),1)*mat(Tmat(1),2);
    F0_prima=F0e*[-1; 0; 1; 0];
    F0e=inv(Re)*F0_prima;
   
    F0el(:,e)=F0e;
end 
F0=zeros(16,1);
for e= 1:n_el
    for i=1:4
        I=Td(e,i);
        F0(I)=F0(I)+F0el(i,e);
    end  
end

% Apply conditions  F A L T A   F E R   B E 
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);

% System resolution
[u,R] = solveSys(vL,vR,uR,KG,Fext,F0);

% Compute strain and stresses
[eps,sig] = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat);

%% POSTPROCESS

% Plot displacements
plotDisp(n_d,n,u,x,Tn,1);

% Plot strains
plotStrainStress(n_d,eps,x,Tn,{'Strain'});

% Plot stress
plotStrainStress(n_d,sig,x,Tn,{'Stress';'(Pa)'});

% Plot stress in defomed mesh
plotBarStressDef(x,Tn,u,sig,5)

%% Buckling

buckling=zeros(n_el,1);

for i=1:n_el
    
    x1e=x(Tn(i,1),1);
    y1e=x(Tn(i,1),2);
    x2e=x(Tn(i,2),1);
    y2e=x(Tn(i,2),2);
    
    le = sqrt( ((x2e-x1e)^2) + ((y2e-y1e)^2) );
    
    sigCrit(i,1) = (( pi*pi*mat(Tmat(i),1)*Inertia) / ( le*le* mat(Tmat(i),2)))/1000000;
    
    if sig(i,1)<0
        aux=-sig(i,1);
       if aux>sigCrit(i,1)
           buckling(i,1)=1;
       end
    end
end
