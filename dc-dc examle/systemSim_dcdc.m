clc
clear
load model
switchTime = switchInfo.switchTime;
dataIndex = systemInfo.segmentIndex;
subsystem = systemInfo.subsystem;
Ts = 1e-2;

K = 0:1:switchTime(end);
K = K*Ts;

% ELM simulation
segmentIndex = 1;
for i = 1:1:length(dataIndex)
    if any(dataIndex{i} == segmentIndex)
        activeSysIndex = i;
        break;
    end
end

%x0 = [7;40];
x0 = [0.5;0.5];
x_elm = x0;
for k = 1:1:switchTime(end)
    x_elm = elmpredict(x_elm,subsystem{activeSysIndex});
    X_elm(:,k) = x_elm;
    if k == switchTime(segmentIndex+1)
        segmentIndex = segmentIndex + 1;
        for i = 1:1:length(dataIndex)
            if any(dataIndex{i} == segmentIndex)
                activeSysIndex = i;
                break;
            end
        end
    end
    switching_elm(:,k) = activeSysIndex;
end

X_elm = [x0,X_elm];

% Original system simulation
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

x = x0;
for k=1:1:switchTime(end)
    if k/T - floor(k/T)<(1.5/2.5)
        i = 1;
    else
        i = 2;
    end
    switch i
        case 1
            x = A1*x + B1*E;
        case 2
            x = A2*x + B2*E;
    end
    X(:,k) = x;
    switching(:,k) = i;
end
X = [x0,X];

subplot(2,1,1)
plot(K,X,'LineWidth',1)
title("State responses of DC-DC model")
xlabel('t(ms)')
ylabel('x_{orignal}');
ylim([0 110])
legend({'x_1','x_2'},'Location','northeast')

subplot(2,1,2)
plot(K,X_elm,'LineWidth',1)
title("State responses of data-driven model")
xlabel('t(ms)')
ylabel('x_{data-driven}');
ylim([0 110])
legend({'x_1','x_2'},'Location','northeast')

figure
plot(X(1,:),X(2,:))
hold on
plot(X_elm(1,:),X_elm(2,:),'--','LineWidth',1)
title("State trajectories")
xlabel('x_1')
ylabel('x_2');
legend({'DC-DC model','Data-driven model'},'Location','northwest')

Ts = 1e-2;
K = 1:1:switchTime(end);
K = K*Ts;

figure
subplot(2,1,1)
plot(K,switching,'LineWidth',1)
title("Switching instants of DC-DC model")
xlabel('t(ms)')
ylabel('\sigma_{DC-DC}');
ylim([0 3])

subplot(2,1,2)
plot(K,switching_elm,'LineWidth',1)
title("Switching instants of data-driven model")
xlabel('t(ms)')
ylabel('\sigma_{data-driven}');
ylim([0 3])





