clc
clear
K_train = 1000 % number of training data for each initial state
numX0 = 20; % number of initial states

L = 1e-3;
RL = 0.1;
C = 10e-6;
RC = 0.06;
R = 10;

A1 = [-RL/L 0; 0 -1/((R+RC)*C)];
A2 = [-(RL+RC*R/(R+RC))/L -R/(L*(R+RC));R/(C*(R+RC)) -1/(C*(R+RC))];

B1 = [1/L ; 0];
B2 = B1;

C1 = [1 0; 0 1];
C2 = C1;

D1 = [0;0];
D2 = D1;

E = 20;

subsystem_1 = ss(A1,B1,C1,D1);
subsystem_2 = ss(A2,B2,C2,D2);

Ts = 1e-5;

T = round((2e-4)/Ts);

subsystem_1 = c2d(subsystem_1,Ts);
subsystem_2 = c2d(subsystem_2,Ts);

A1 = subsystem_1.A;
B1 = subsystem_1.B;
A2 = subsystem_2.A;
B2 = subsystem_2.B;

inputData = [0;0];
outputData = [0;0];
% Training data

for j = 1:1:numX0
    %x0 = [6+4*rand;25+25*rand];
    x0 = rand(2,1);
    x = x0;
    for k=1:1:K_train
        if k/T - floor(k/T)<(1.5/2.5)
            i = 1;
        else
            i = 2;
        end
        switch i
            case 1
                inputData = [inputData,x];
                x = A1*x + B1*E;
                outputData = [outputData,x];
            case 2
                inputData = [inputData,x];
                x = A2*x + B2*E;
                outputData= [outputData,x];
        end
        X(:,k) = x;
        switching(:,k) = i;
    end
end
inputData(:,1) = [];
outputData(:,1) = [];

K = 1:1:K_train;
plot(K,X)
title("State responses")
xlabel('k')
ylabel('x');
save train_Data inputData outputData K_train
