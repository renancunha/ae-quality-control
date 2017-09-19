function [ result, Fs ] = clip_around_peak( wavFile, interval )
    [data, F_s] = wavread(wavFile);
    % Fs is 44100
    % assuming data is a single-channel recording
    N = length(data);
    % total duration
    totaldur = N/F_s;
    % create a time vector
    t = linspace(0,totaldur,N);
    % I'm using logical indexing here
    
    [num idx] = max(data);
    dt = 1/F_s;
    time = idx*dt
    half_interval = interval/2;
    
    seg1 = data(t>(time-half_interval) & t<(time+half_interval)); % get the data between 0.2 and 0.4 seconds
    
    result = seg1;
    Fs = F_s;
end

