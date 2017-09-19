function kNN_model_add_class(modelName, className, classPath, ...
    listOfStatistics, stWin, stStep, mtWin, mtStep)

%
% function kNN_model_add_class(modelName, className, classPath, ...
%         listOfStatistics, stWin, stStep, mtWin, mtStep)
%
% This function adds an audio class to the kNN classification model
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
% kNN_model_add_class('modelSpeech.mat', 'speech', './Music/', ...
%  {'mean','std',}, 0.050, 0.025, 2.0, 1.0);
%

if ~exist(classPath,'dir')
    error('Audio sample path is not valid!');
else
    classPath = [classPath filesep];
end

% check if the model elaready exists:
fp = fopen(modelName, 'r');
if fp>0 % check if file already exists
    load(modelName);
end

% Feature extraction:
D = dir([classPath '*.wav']);
F = [];
for (i=1:length(D)) % for each wav file in the given path:
    curFileName = [classPath D(i).name];
    FileNamesTemp{i} = curFileName;
    % mid-term feature extraction for each wav file:
    midFeatures = featureExtractionFile(curFileName, ...
        stWin, stStep, mtWin, mtStep, listOfStatistics);

    % long-term averaging:
    longFeatures = mean(midFeatures,2);       
    
    F = [F longFeatures];
end

% save the model:
Statistics = listOfStatistics;
fp = fopen(modelName, 'r');
if fp<0 % model does not exist --> generate     
    ClassNames{1} = className;
    Features{1} = F;   
    FileNames{1} = FileNamesTemp;
    save(modelName, 'ClassNames', 'Features', ...
        'Statistics', 'stWin', 'stStep', 'mtWin', 'mtStep', 'FileNames');
else
    load(modelName);
    ClassNames{end+1} = className;
    Features{end+1} = F;
    FileNames{end+1} = FileNamesTemp;
    save(modelName, 'ClassNames', 'Features', ...
        'Statistics', 'stWin', 'stStep', 'mtWin', 'mtStep', 'FileNames');
end

if(fp > 0)
   fclose(fp); 
end
