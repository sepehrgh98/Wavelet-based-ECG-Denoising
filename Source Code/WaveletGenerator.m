clc;
clear;

h = [0.001590, -0.056193, 0.056736, 0.493436, 0.493436, 0.056736, -0.056193, 0.001590];

h = h / sum(h);

phi = zeros(1, 2048); 
phi(floor(length(phi)/2)) = 1; 

iterations = 8; 
for i = 1:iterations
    phi = conv(phi, h); 
    phi = phi / sum(phi); 
end


midpoint = floor(length(phi)/2);
range = (midpoint-20):(midpoint+20); 

% Plot phi
figure(1);
plot(range, phi(range));
title('Scaling Function');
grid on;

g = zeros(1, length(h));
for n = 1:length(h)
    g(n) = (-1)^n * h(length(h) - n + 1); 
end


psi = [1]; 
for i = 1:iterations
    psi = conv(psi, g); 
    psi = psi / norm(psi, 2); 
end

% Plot psi
figure(2);
plot(psi);
title('Wavelet Function');
grid on;


% Save Results
save("..\Results\phi.mat", "phi");
save("..\Results\psi.mat", "psi");