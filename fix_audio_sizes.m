folder_name = 'samples/ceramic_tiles/bad/';
files_to_test = dir([folder_name]);
files_to_test(1) = []; files_to_test(1) = [];

X = [];
n_samples = 30800;
for l = 1:length(files_to_test)
% for l = 9:9
    [y, Fs] = wavread([folder_name files_to_test(l).name]);
    X = [X; length(y)];
    y_n = zeros(n_samples, 1);
    
    if(size(y, 1) < n_samples)
        y_n(1:size(y, 1)) = y;
    else
        y_n = y(1:n_samples);
    end;
     
    wavwrite(y_n, Fs, [folder_name files_to_test(l).name]);
end