function [ ] = plot_audio_file_db( wavFile )

[y, Fs] = audioread(wavFile);
dB = mag2db(abs(y));

dt = 1/Fs;
t = 0:dt:(length(y)*dt)-dt;
plot(t,dB); xlabel('Seconds'); ylabel('Amplitude');
%figure
%plot(psd(spectrum.periodogram,y,'Fs',Fs,'NFFT',length(y)));

end

