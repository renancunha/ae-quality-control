function [PATH_TRAIN, PATH_VALIDATION, PATH_TEST] = randomize_samples( files_path_good, files_path_bad, new_path, pct_train, pct_validation, pct_test )

files_good = dir(files_path_good);
files_good(1) = []; files_good(1) = [];
count_good = length(files_good);

files_bad = dir(files_path_bad);
files_bad(1) = []; files_bad(1) = [];
count_bad = length(files_bad);

all_good = randperm(count_good, count_good);
all_bad = randperm(count_bad, count_bad);    

count_train_good = ceil(count_good*pct_train);
train_good = all_good(1:count_train_good);

count_validation_good = ceil(count_good*pct_validation);
validation_good = all_good(count_train_good+1:count_train_good+count_validation_good);

count_test_good = ceil(count_good*pct_test);
test_good = all_good(count_train_good+count_validation_good+1:count_train_good+count_validation_good+count_test_good);


count_train_bad = ceil(count_bad*pct_train);
train_bad = all_bad(1:count_train_bad);

count_validation_bad = ceil(count_bad*pct_validation);
validation_bad = all_bad(count_train_bad+1:count_train_bad+count_validation_bad);

count_test_bad = ceil(count_bad*pct_test);
test_bad = all_bad(count_train_bad+count_validation_bad+1:count_train_bad+count_validation_bad+count_test_bad);

% remove if folder already exists
if(exist(new_path,'dir'))
    rmdir(new_path, 's');
end

% create folders
mkdir(new_path);
mkdir([new_path 'train\']);
mkdir([new_path 'train\' 'good\']);
mkdir([new_path 'train\' 'bad\']);
mkdir([new_path 'validation\']);
mkdir([new_path 'test\']);

PATH_TRAIN = [new_path 'train\'];
PATH_VALIDATION = [new_path 'validation\'];
PATH_TEST = [new_path 'test\'];

% move files
for i = 1:count_train_good
    file_name = files_good(train_good(i)).name;
    copyfile([files_path_good file_name], [PATH_TRAIN 'good\' file_name]);
end

for i = 1:count_validation_good
    file_name = files_good(validation_good(i)).name;
    copyfile([files_path_good file_name], [PATH_VALIDATION file_name]);
end

for i = 1:count_test_good
    file_name = files_good(test_good(i)).name;
    copyfile([files_path_good file_name], [PATH_TEST file_name]);
end

for i = 1:count_train_bad
    file_name = files_bad(train_bad(i)).name;
    copyfile([files_path_bad file_name], [PATH_TRAIN 'bad\' file_name]);
end

for i = 1:count_validation_bad
    file_name = files_bad(validation_bad(i)).name;
    copyfile([files_path_bad file_name], [PATH_VALIDATION file_name]);
end

for i = 1:count_test_bad
    file_name = files_bad(test_bad(i)).name;
    copyfile([files_path_bad file_name], [PATH_TEST file_name]);
end

end

