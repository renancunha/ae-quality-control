Statistics = {'mean', 'median', 'std', 'stdbymean', 'max', 'min'};

stWin = 0.040; stStep = 0.040;
mtWin = 0.4; mtStep = 0.1;

kNN_model_add_class('modelnovo.mat', 'boa', 'telhas/boas/train', Statistics, stWin, stStep, mtWin, mtStep);
kNN_model_add_class('modelnovo.mat', 'ruim', 'telhas/ruins/train', Statistics, stWin, stStep, mtWin, mtStep);