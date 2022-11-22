classdef Force_TEST < matlab.unittest.TestCase
    methods(Test)
        function externalForce(testCase)
            F = 920;
            Fdata = [   2   2   3*F;
                        3   2   2*F;
                        4   2   F;
                    ];
            actSolution = computeF(16,Fdata);
            expSolution = [0;0;0;3*F;0;2*F;0;F;0;0;0;0;0;0;0;0];
            testCase.verifyEqual(actSolution,expSolution)
        end
    end
    
end