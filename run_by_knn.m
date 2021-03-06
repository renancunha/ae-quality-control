% %clear;
% 
% % prepare datasets
% [PATH_TRAIN, PATH_VALIDATION, PATH_TEST] = randomize_samples('samples/ceramic_tiles/good/', ...
%                                                              'samples/ceramic_tiles/bad/', ...
%                                                              'test_0711/', ...
%                                                              0.6, 0.2, 0.2);

stWin = 0.010; stStep = 0.010;


mtWin = 0.1; mtStep = 0.1;
Statistics = {'mean', 'median', 'std', 'stdbymean', 'max', 'min'};
Ks = [1 2 4 3 5 10 15 20];

TUNNING_RESULTS = [];
for i = 1 : length(Ks)
   [ acc ] = classify_knn( PATH_TRAIN, PATH_VALIDATION, stWin, stStep, mtWin, mtStep, Statistics, Ks(i) );
   TUNNING_RESULTS = [TUNNING_RESULTS; acc Ks(i)]; 
end

[best_accuraccy, best_accuraccy_index] = max(TUNNING_RESULTS(:, 1));

best_K = Ks(best_accuraccy_index);
[ accuraccy, TP, FP, TN, FN ] = classify_knn( PATH_TRAIN, PATH_TEST, stWin, stStep, mtWin, mtStep, Statistics, best_K );

