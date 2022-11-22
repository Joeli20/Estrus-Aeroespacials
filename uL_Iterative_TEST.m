classdef uL_Iterative_TEST < matlab.unittest.TestCase
    methods(Test)
        function uLTest(testCase)
            load('dataMainIt.mat','RHS','LHS','u','uR','vL','vR');
            st.RHS = RHS;
            st.LHS = LHS;

            calculuL = SolveuLiterative(st);
            calculuL.obteniruL;
            uL = calculuL.uL;
            u_t(vL,1)=uL;
            u_t(vR,1)=uR;

            actSolution = u_t;
            expSolution = u;

            testCase.verifyEqual(actSolution,expSolution);
        end
    end
end