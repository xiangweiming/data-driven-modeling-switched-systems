clc
clear
load train_Data
e_switchDetect = 0.002;
e_systemModeling = 1;
neurons = 200;
switchInfo = switchDetect(inputData,outputData,K_train,e_switchDetect);
systemInfo = systemModeling(switchInfo.inputDataSegmented,switchInfo.outputDataSegmented,switchInfo.switchTime,neurons,e_systemModeling)

save model systemInfo switchInfo

