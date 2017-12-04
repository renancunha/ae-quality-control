function [ accuraccy, rank ] = classify_svm( PATH_TRAIN, PATH_TEST, stWin, stStep, mtWin, mtStep, Statistics, kernel_func, k_features )

    MODEL_NAME = ['svm_' datestr(now,'ddmmyyyy_HHMMSSFFF') '.mat'];
    MODEL_PATH = ['models\' MODEL_NAME];
    
    svm_model_add_class(MODEL_PATH, [PATH_TRAIN 'good'], [PATH_TRAIN 'bad'], Statistics, stWin, stStep, mtWin, mtStep, kernel_func, k_features);      

    correct_predictions = 0;
    wrong_predictions = 0;
    
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;

    files_to_test = dir(PATH_TEST);
    files_to_test(1) = []; files_to_test(1) = [];

    load(MODEL_PATH);
    rank = ranking;
%     rank = 0;
    
    for l = 1:length(files_to_test)
        [y, Fs] = wavread([PATH_TEST files_to_test(l).name]);
        stF = stFeatureExtraction(y, Fs, stWin, stStep);
        mtWinRatio = mtWin/stWin;
        mtStepRatio = mtStep/stStep;
        [mtFeatures] = mtFeatureExtraction(stF, mtWinRatio, mtStepRatio, Statistics);
        mtFeatures = mean(mtFeatures, 2);
        
        features = mtFeatures';
%         label = svmclassify(SVMStruct, features);
        label = svmclassify(SVMStruct, features(ranking(1:k_features)));

        if(strfind(files_to_test(l).name, 'b'))
            if(label == 1)
                correct_predictions = correct_predictions + 1;
                TP = TP + 1;
            else
                wrong_predictions = wrong_predictions + 1;
                FP = FP + 1;
            end;
        elseif(strfind(files_to_test(l).name, 'r'))
            if(label == 2)
                correct_predictions = correct_predictions + 1;
                TN = TN + 1;
            else
                wrong_predictions = wrong_predictions + 1;
                FN = FN + 1;
            end;
        end;

    end;

    accuraccy = (TP+TN)/(TP+TN+FP+FN);
end

