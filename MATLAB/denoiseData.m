function filtered = denoiseData(noisyData, dt, threshold)
% dt = .001;

f = noisyData;
n = length(noisyData);
t = 0:dt:(n-1)*dt;
% f_clean = sin(2*pi*50*t) + sin(2*pi*120*t); % Sum of 2 frequencies
% f = f_clean + 2.5*randn(size(t)); % Add some noise
%% Compute the Fast Fourier Transform FFT

fhat = fft(f,n); % Compute the fast Fourier transform
PSD = fhat.*conj(fhat)/n; % Power spectrum (power per freq)
freq = 1/(dt*n)*(0:n); % Create x-axis of frequencies in Hz
L = 1:floor(n/2); % Only plot the first half of freqs
%% Use the PSD to filter out noise
indices = PSD>threshold; % Find all freqs with large power
PSDclean = PSD.*indices; % Zero out all others
fhat = indices.*fhat; % Zero out small Fourier coeffs. in Y
ffilt = ifft(fhat); % Inverse FFT for filtered time signal
%% PLOTS
subplot(3,1,1)
plot(t,f,'r','LineWidth',1), hold on
% plot(t,f_clean,'r','LineWidth',1.2), hold on
legend('Noisy','Clean')
subplot(3,1,2)
plot(t,f,'k','LineWidth',1), hold on
plot(t,ffilt,'b','LineWidth',1)
legend('Clean','Filtered')
subplot(3,1,3)
plot(freq(L),PSD(L),'r','LineWidth',1.5), hold on
plot(freq(L),PSDclean(L),'-b','LineWidth',1.2)
legend('Noisy','Filtered')
filtered=ffilt;

end