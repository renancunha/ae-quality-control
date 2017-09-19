stWin = 0.010; stStep = 0.010;
mtWin = 0.1; mtStep = 0.1;
Statistics = {'mean', 'median', 'std', 'stdbymean', 'max', 'min'};
kNN = 4;

kNN_model_add_class(['modelo_1.mat'], 'good', ['path/to/good/train/'], Statistics, stWin, stStep, mtWin, mtStep);
kNN_model_add_class(['modelo_1.mat'], 'bad', ['path/to/bad/train/'], Statistics, stWin, stStep, mtWin, mtStep);           

correct_predictions = 0;
wrong_predictions = 0;

files_to_test = dir(['path/to/validation/']);
files_to_test(1) = []; files_to_test(1) = [];

[Features, ClassNames, MEAN, STD, Statistics, ...
    stWin, stStep, mtWin, mtStep] = kNN_model_load('modelo_1.mat');

for l = 1:length(files_to_test)
    [y, Fs] = wavread(['path/to/validation/' files_to_test(l).name]);
    stF = stFeatureExtraction(y, Fs, stWin, stStep);
    mtWinRatio = mtWin/stWin;
    mtStepRatio = mtStep/stStep;
    [mtFeatures] = mtFeatureExtraction(stF, mtWinRatio, mtStepRatio, Statistics);
    mtFeatures = mean(mtFeatures, 2);
    [P, label] = classifyKNN_D_Multi(Features, (mtFeatures - MEAN') ./ STD', kNN, 1);

    if(strfind(files_to_test(l).name, 'b'))
        if(label == 1)
            correct_predictions = correct_predictions + 1;
        else
            wrong_predictions = wrong_predictions + 1;
        end;
    elseif(strfind(files_to_test(l).name, 'r'))
        if(label == 2)
            correct_predictions = correct_predictions + 1;
        else
            wrong_predictions = wrong_predictions + 1;
        end;
    end;

end;