function [ result, Fs ] = clip_audio( wavFile, startClip, endClip )
    [data, F_s] = wavread(wavFile);
    % Fs is 44100
    % assuming data is a single-channel recording
    N = length(data);
    % total duration
    totaldur = N/F_s;
    % create a time vector
    t = linspace(0,totaldur,N);
    % I'm using logical indexing here
    seg1 = data(t>startClip & t<endClip); % get the data between 0.2 and 0.4 seconds
    
    result = seg1;
    Fs = F_s;
end

