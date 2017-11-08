FOLDER_PATH = 'telhas2/ruins/';

files = dir(FOLDER_PATH);

for i = 3:length(files)

    if(strcmp(files(i).name, 'clipped'))
        continue;
    end;
    FILE_PATH = strcat(FOLDER_PATH, files(i).name);
    CLIPPED_FILE_PATH = strcat(FOLDER_PATH, 'clipped/', num2str(i-3), 'r.wav')
    [xC, FsC] = clip_around_peak(FILE_PATH, 0.8);
    wavwrite(xC, FsC, CLIPPED_FILE_PATH);
end