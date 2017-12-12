function svm_model_add_class(modelName, classPathOne, classPathTwo, ...
    listOfStatistics, stWin, stStep, mtWin, mtStep, kernel_func, k_features)

%
% function svm_model_add_class(modelName, className, classPath, ...
%         listOfStatistics, stWin, stStep, mtWin, mtStep)
%
% This function adds an audio class to the SVM classification model
% 
% ARGUMENTS;
% - modelName:  the filename of the model (mat file)
% - className:  the name of the audio class to be added to the model
% - classPath:  the path of the directory where the audio segments of the
%               new class are stored
% - listOfStatistics:   list of mid-term statistics (cell array)
% - stWin, stStep:      short-term window size and step
% - mtWin, mtStep:      mid-term window size and step
%
% Example:
% svm_model_add_class('modelSpeech.mat', 'speech', './Music/', ...
%  {'mean','std',}, 0.050, 0.025, 2.0, 1.0);
%

if ~exist(classPathOne,'dir')
    error('Audio sample path is not valid!');
else
    classPathOne = [classPathOne filesep];
end

if ~exist(classPathTwo,'dir')
    error('Audio sample path is not valid!');
else
    classPathTwo = [classPathTwo filesep];
end

% check if the model elaready exists:
fp = fopen(modelName, 'r');
if fp>0 % check if file already exists
    load(modelName);
end

% Feature extraction:
D1 = dir([classPathOne '*.wav']);
F1 = [];
for (i=1:length(D1)) % for each wav file in the given path:
    curFileName = [classPathOne D1(i).name];
    FileNamesTemp{i} = curFileName;
    % mid-term feature extraction for each wav file:
    midFeatures = featureExtractionFile(curFileName, ...
        stWin, stStep, mtWin, mtStep, listOfStatistics);

    % long-term averaging:
    longFeatures = mean(midFeatures,2);       
    
    F1 = [F1; longFeatures'];
end

% Feature extraction:
D2 = dir([classPathTwo '*.wav']);
F2 = [];
for (i=1:length(D2)) % for each wav file in the given path:
    curFileName = [classPathTwo D2(i).name];
    FileNamesTemp{i} = curFileName;
    % mid-term feature extraction for each wav file:
    midFeatures = featureExtractionFile(curFileName, ...
        stWin, stStep, mtWin, mtStep, listOfStatistics);

    % long-term averaging:
    longFeatures = mean(midFeatures,2);       
    
    F2 = [F2; longFeatures'];
end

Training = [F1; F2];
Group = zeros(size(F1, 1) + size(F2, 1), 1);
Group(1:size(F1, 1)) = 1;
Group(size(F1, 1)+1:size(F1, 1)+size(F2, 1)) = 2;

%[ ranking , w] = reliefF( Training, Group, size(Training, 2));
ranking = 1:size(Training, 2);

SVMStruct = svmtrain(Training ,Group, 'kernel_function', kernel_func);
% SVMStruct = svmtrain(Training(:, ranking(1:k_features)) ,Group, 'kernel_function', kernel_func);
% save(modelName, 'Training', 'Group', 'SVMStruct', 'ranking');
save(modelName, 'Training', 'Group', 'SVMStruct');


