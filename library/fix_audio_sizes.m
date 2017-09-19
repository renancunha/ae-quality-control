folder_name = 'pisos2/teste/treino/b/';
files_to_test = dir([folder_name]);
files_to_test(1) = []; files_to_test(1) = [];

for l = 1:length(files_to_test)
% for l = 9:9
    [y, Fs] = wavread([folder_name files_to_test(l).name]);
    total_samples = Fs*0.5;
    y_n = zeros(total_samples, 1);
    
    if(size(y, 1) < total_samples)
        y_n(1:size(y, 1)) = y(1:size(y, 1));
    else
        y_n = y(1:total_samples);
    end;
    
    wavwrite(y_n, Fs, [folder_name files_to_test(l).name]);
end