function [ result, Fs ] = clip_audio_around_peak( data, Fs, interval )
    F_s = Fs;
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
    time = idx*dt;
    intervalBy3 = interval/5;
    lower_interval = intervalBy3;
    upper_interval = intervalBy3*5;
    
    seg1 = data(t>(time-lower_interval) & t<(time+upper_interval)); % get the data between 0.2 and 0.4 seconds
    
    result = seg1;
    Fs = F_s;
end

