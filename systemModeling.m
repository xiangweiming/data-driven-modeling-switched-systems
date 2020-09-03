function systemInfo = systemModeling(inputDataSegmented,outputDataSegmented,switchTime,neurons,e)

lengthSegment = length(inputDataSegmented);

for i = 1:1:lengthSegment
    ELMNetwork = elmtrain(inputDataSegmented{i},outputDataSegmented{i},neurons,'sig',0);
    error(i) = ELMNetwork.trainingError;
end

for i = 1:1:length(switchTime)-1
    segmentIndex{i} = i;
end

m1 = 1;
k = 0;
while m1 <  lengthSegment
    m2 = m1 + 1;
    while m2 <= lengthSegment
        inputData = [inputDataSegmented{m1},inputDataSegmented{m2}];
        outputData = [outputDataSegmented{m1},outputDataSegmented{m2}];
        ELMNetwork = elmtrain(inputData,outputData,neurons,'sig',0);
        k = k + 1;
        %error(k) = ELMNetwork.trainingError;
        if ELMNetwork.trainingError < e
            inputDataSegmented{m1} = inputData;
            inputDataSegmented(m2) = [];
            outputDataSegmented{m1} = outputData;
            outputDataSegmented(m2) = [];
            segmentIndex{m1} = [segmentIndex{m1},segmentIndex{m2}];
            segmentIndex(m2) = [];
            lengthSegment = lengthSegment - 1;
        else
            m2 = m2 + 1;
        end
    end
    m1 = m1 + 1;
end

for i = 1:1:length(inputDataSegmented)
    ELMNetwork = elmtrain(inputDataSegmented{i},outputDataSegmented{i},neurons,'sig',0);
    subsystem{i} = ELMNetwork;
end
figure;
plot(error);
systemInfo.subsystem = subsystem;
systemInfo.segmentIndex = segmentIndex;
