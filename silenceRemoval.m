function [segs, classes, Labels, centers] = silenceRemoval(fileName, segMethod, PLOT)

% function [segs, classes] = silenceRemoval(fileName, PLOT)
%
% This function applies a semi-supervised algorithm for detecting speech
% segments (removing silence ones) in an audio stream stored in a wav file.
%
% ARGUMENTS
%  - fileName:      the name of the input WAV file
%  - PLOT:          1 if  results are to be plotted, 0 otherwise
%  - segMethod:     segmentation method: 0 for simple merging
%                                        1 for viterbi smoothing
%
% OUTPUT:
%  - segs:          numOfSegs x 2 matrix: segs(i,1) is the beginning and
%                   segs(i,2) the end of the segment i
%  - classes:       class(i) (i=1..numOfSegs) is the label of segment i
%  - Labels:        labels array (for each midterm window) (0 for silece, 1
%                   for speech)
%  - centers:       time center of each mid-term window
%
% (c) 2014 T. Giannakopoulos, A. Pikrakis

% Read the file information (size etc):
[samples, fs] = wavread(fileName, 'size');
signalDuration = samples(1) / fs;
mtWin = 1.0;
mtStep = 0.05;
stWin = 0.0250;
stStep = 0.0250;
Statistics = {'mean', 'std'};

% STEP A: Extract mid-term statistics:
[mtFeatures, centers] = featureExtractionFile(...
    fileName,  stWin, stStep, mtWin, mtStep, Statistics);

if length(centers)<5
    error 'At least 5 mid-term windows are needed for this algorithm to be executed!'
end

% STEP B: Train the "silence vs speech" kNN model

% Keep mid-term (mean) energy sequence (1st statistic - 2nd feature):
mtMeanEnergy = mtFeatures(2, :);
numOfWindows = size(mtMeanEnergy, 2);

perTrain = 0.20; % percentage of the data that will be used for training
mtMeanEnergySort = sort(mtMeanEnergy);
% low threshold  (if Mean Energy < T1 then it is used as training 
% data for "silence"):
T1 = mtMeanEnergySort(round(perTrain * numOfWindows));          
% high threshold (if Mean Energy > T2 then it is used as training data 
% for "speech")
T2 = mtMeanEnergySort(end-round(perTrain * numOfWindows)+1);    

flags = mtMeanEnergy;

% Split the training data:
Features = {};
Ind1 = find(mtMeanEnergy<=T1);
Features{1} = mtFeatures(:, Ind1);      % for silence
Ind2 = find(mtMeanEnergy>=T2);
Features{2} = mtFeatures(:, Ind2);      % for speech


% Train the kNN model
ClassNames = {'silence', 'speech'};

% save the kNN model
save('silenceModelTemp', 'ClassNames', 'Features', 'Statistics', ...
    'stWin', 'stStep', 'mtWin', 'mtStep');

% and re-load it (this is done for loging purposes and for computing the
% MEAN and STD arrays):
[Features, ClassNames, MEAN, STD, Statistics, stWin, stStep, mtWin, mtStep] = ...
    kNN_model_load('silenceModelTemp');


% STEP C: RUN the kNN classifier on the whole sequence of mid-term feature
% vectors of the input signal
kNN = round(size(Features{1}, 2)/3);

if mod(kNN,2)==0 kNN = kNN + 1; end

for i=1:numOfWindows % for each mid-term window:
    % classify the current mid-term window using the learned kNN classifier
    [Ps(i,:), labels(i)] = classifyKNN_D_Multi(...
        Features, (mtFeatures(:,i) - MEAN') ./ STD', kNN, 1);
end

% bias-weighting: we give more weight to the speech class.
% this is equivalent to setting a lower threshold
probWeights = [1 3];
Ps(:, 1) = Ps(:, 1) * probWeights(1);
Ps(:, 2) = Ps(:, 2) * probWeights(2);

% re-normalize the probabilities, so that each sum is 1:
for i=1:numOfWindows
    Ps(i,:) = Ps(i,:) ./ sum(Ps(i,:));
end

[segs, classes, Labels] = segmentationProbSeq(Ps, centers, signalDuration, segMethod);

% PLOT if required: (for demonstration purposes)
if (PLOT==1)
    subplot(3,1,1); plot([0:length(flags)-1] *mtStep, flags,'r');
    L2 = line([0 length(flags)]*mtStep, [T1 T1]); set(L2, 'LineWidth', 2);
    L3 = line([0 length(flags)]*mtStep, [T2 T2]); set(L3, 'LineWidth', 2);
    title('Mid-term Energy and T1, T2 thresholds');

    subplot(3,1,2); plot(centers, Ps(:,2),'r');
    title('Speech kNN probability');
        
    x = wavread(fileName);
    
    indSegsSpeech = find(classes==1);
    for i=1:length(indSegsSpeech)
        L1 = round(segs(indSegsSpeech(i),1) * fs) + 1;
        L2 = round(segs(indSegsSpeech(i),2) * fs);

        if (L1<1) L1 = 1; end
        if (L2>length(x)) L2 = length(x); end
        xTemp = wavread(fileName, [L1 L2]);
        subplot(3,1,3); cla
        plot(0:1/fs:(length(x)-1)/fs, x);
        hold on;
        plot([L1:L2] / fs, xTemp,'r');
        legend({'Signal','Current Speech Segment'}); drawnow
        sound(xTemp, fs)        
        pause
    end
end
