function [ ] = plot_audio( y, Fs )

dt = 1/Fs;
t = 0:dt:(length(y)*dt)-dt;
plot(t,y); xlabel('Seconds'); ylabel('Amplitude');
%figure
%plot(psd(spectrum.periodogram,y,'Fs',Fs,'NFFT',length(y)));

end

