%% Generate predefined matrixcalc

matrixcalc = zeros(6);
AI = 1;

%{

for j=[1:4]
for i=[1:4]
    %matrixcalc(i) = 1;
    matrixcalc(i,j) = 1;
    
end
end

matrixcalc(3,1:4)=2;
matrixcalc(6,1:4)=2;
%}

matrixcalc(1:2:5,2:2:6) = 1;
matrixcalc(1:2:5,1:2:5) = 2;
matrixcalc(2:2:6,1:2:5) = 1;
matrixcalc(2:2:6,2:2:6) = 2;
%matrixcalc(end) = 0;
save matrixcalc.mat matrixcalc AI
pentago()