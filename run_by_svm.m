% clear;
% 
% %prepare datasets
[PATH_TRAIN, PATH_VALIDATION, PATH_TEST] = randomize_samples('samples/ceramic_tiles/good/', ...
                                                              'samples/ceramic_tiles/bad/', ...
                                                              'test_0711/', ...
                                                              0.6, 0.2, 0.2);

stWin = 0.010; stStep = 0.010;
mtWin = 0.1; mtStep = 0.1;
Statistics = {'mean', 'median', 'std', 'stdbymean', 'max', 'min'};

% svm kernels
Kernels = {'linear', 'quadratic', 'polynomial', 'rbf', 'mlp'};

% feature selection
k_features = 210;

TUNNING_RESULTS = [];
for i = 1 : length(Kernels)
   [ acc, rank ] = classify_svm( PATH_TRAIN, PATH_VALIDATION, stWin, stStep, mtWin, mtStep, Statistics, Kernels{i}, k_features );
   TUNNING_RESULTS = [TUNNING_RESULTS; acc Kernels(i)]; 
end

[best_accuraccy, best_accuraccy_index] = max([TUNNING_RESULTS{:, 1}]);

best_kernel = Kernels{best_accuraccy_index};
[ accuraccy, rank ] = classify_svm( PATH_TRAIN, PATH_TEST, stWin, stStep, mtWin, mtStep, Statistics, best_kernel, k_features );

