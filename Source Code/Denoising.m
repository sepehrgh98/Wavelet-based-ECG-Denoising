clc;
clear;

% Load data
filename = 'ECGData.mat';
loadedData = load(filename);

disp('Variables loaded from the file:');
disp(fieldnames(loadedData));

data = loadedData.ECGData.Data;
sampleToPlot = data(1, 1:1000);

figure(1); 
plot(sampleToPlot);
title('ECG Signal');
xlabel('Time');
ylabel('value');
ylim([-1,2]);
grid on;

% Add white Gaussian noise to the signal
noiseLevel = 0.03;
noisySignal = sampleToPlot + randn(size(sampleToPlot)) * noiseLevel;

% Load Filters
load("..\Results\phi.mat");
load("..\Results\psi.mat")

% Decomposition
approximation = downsample(conv(noisySignal, phi, 'same'), 2);
detail = downsample(conv(noisySignal, psi, 'same'), 2);

% Thresholding logic
threshold = sqrt(2 * log(length(detail)));
detail(abs(detail) < threshold) = 0;

% Reconstruction filters
reconPhi = flip(phi); % 
reconPsi = flip(psi); % 

% Reconstruction
upsampledApproximation = conv(upsample(approximation, 2), reconPhi, 'same');
upsampledDetail = conv(upsample(detail, 2), reconPsi, 'same');

denoisedSignal = upsampledApproximation + upsampledDetail;


% Denoising using famous wavelets
% db4
[denoisedSignal_db4, ~, ~] = wdenoise(noisySignal, 5, 'Wavelet', 'db4');

% sym4
[denoisedSignal_sym4, ~, ~] = wdenoise(noisySignal, 5, 'Wavelet', 'sym4');

% Plot 
figure(2);
subplot(5,1,1);
plot(sampleToPlot);
title('Original Signal');
grid on;

subplot(5,1,2);
plot(noisySignal);
title('Noisy Signal');
grid on;

subplot(5,1,3);
plot(denoisedSignal_db4);
title('Denoised with db4');
grid on;

subplot(5,1,4);
plot(denoisedSignal_sym4);
title('Denoised with sym4');
grid on;

subplot(5,1,5);
plot(denoisedSignal);
title('Denoised Signal with fiber');
grid on;



