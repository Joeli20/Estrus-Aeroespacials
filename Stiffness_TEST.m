classdef Stiffness_TEST < matlab.unittest.TestCase
    methods(Test)
        function assemblyTest(testCase)
            load('dataMain.mat','KG','Kel','Td');
            s.n_nod = 2;
            s.n_i = 2;
            s.Td = Td;
            s.Kel = Kel;
            s.n_el = 16;
            s.n_dof = 16;

            ensambladorKG = AssembleKG(s);
            ensambladorKG.juntarKG;
            k_g = ensambladorKG.KG;
            actSolution = k_g;
            expSolution = KG;

            testCase.verifyEqual(actSolution,expSolution);
        end
    end
end