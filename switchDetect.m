function switchInfo = switchDetect(inputData,outputData,K_train,e)
%% function input:
%inputData: training input data, e.g., [x1,x2,x3,....]
%outputData: training output data, e.g., [y1,y2,y3,...]
% K_train: length of the time collecting data
% e: thereshold
%% function output:
% switchInfo.inputDataSegmented: cells of segmented input data for
% subsystem training 
% switchInfo.outputDataSegmented: cells of segmented output data for
% subsystem training 
% switchTime: switching instants, starting from 1, ended with K_train, 


%% Function starts
% switching detection
lengthTrace = K_train;
numTrace = length(outputData)/K_train;
state_step = 1:1:lengthTrace;
for i = 1:1:numTrace
    stateTrace (:,:,i) = inputData(:,(i-1)*K_train+1:i*K_train);
end

s_step = 2:1:lengthTrace-1;
for i = 1:1:numTrace
    for j = 1:1:lengthTrace-2
        s(:,j,i) = stateTrace(:,j+2,i)+stateTrace(:,j,i)-2*stateTrace(:,j+1,i);
        s_norm(j,i) = norm(s(:,j,i))/norm(stateTrace(:,j,i));
    end
end

for i = 1:1:lengthTrace-2
    s_norm_single(i) = sum(s_norm(i,:))/(lengthTrace-2);
end

% segmenting training data
j = 0;
for i = 1:1:lengthTrace-2
    if s_norm_single(i) > e
        j = j + 1;
        switchTime(j) = i+1;
        overThreshold(i) = 1;
    else
        overThreshold(i) = 0;
    end
end

for i = 1:1:length(s_step)
    threshold(i) = e;
end
figure
subplot(2,1,1)
Ts = 1e-2;
plot(s_step*Ts,s_norm_single,'LineWidth',1)  % plot s_norm_single to determine the switching occurence 
hold on
plot(s_step*Ts,threshold,'--','LineWidth',1)
title("Values of sequence ||s(k)||")
xlabel('t(ms)')
ylabel('||s(k)||');
legend({'||s(k)||', 'Threshold'},'Location','northeast')
subplot(2,1,2)
plot(s_step*Ts,overThreshold,'LineWidth',1)
title("Detected switching")
xlabel('t(ms)')
ylabel('Indicator');
ylim([0 1.5])
legend({'1 means occurence of switching'},'Location','northeast')

for i = 1:1:numTrace
    inputDataTrace(:,:,i) = inputData(:,(i-1)*K_train+1:i*K_train);
    outputDataTrace(:,:,i) = outputData(:,(i-1)*K_train+1:i*K_train);
end

switchTime = [1,switchTime,K_train];
for i = 1:1:length(switchTime)-1
    temp_input = [0;0];
    temp_output = [0;0];
    for j = 1:1:numTrace
        temp_input = [temp_input,inputDataTrace(:,switchTime(i):switchTime(i+1)-1,j)];
        temp_output = [temp_output,outputDataTrace(:,switchTime(i):switchTime(i+1)-1,j)];
    end
    temp_input(:,1) = [];
    temp_output(:,1) = [];
    inputDataSegmented{i} = temp_input;
    outputDataSegmented{i} = temp_output;
end

% output: switchInfo
switchInfo.inputDataSegmented = inputDataSegmented;
switchInfo.outputDataSegmented = outputDataSegmented;
switchInfo.switchTime = switchTime;






