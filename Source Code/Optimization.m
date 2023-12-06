clc;
clear;

l = 8;
w1 = linspace(0, pi/2,100);
w2 = linspace(pi/2, pi, 100);
cosine_w1 = cos((0:l-1)' * w1);
cosine_w2 = cos((0:l-1)' * w2);
sine_w1 = sin((0:l-1)' * w1);
sine_w2 = sin((0:l-1)' * w2);


h_n = optimvar('h_n',l);
squre_h_n_w1 = ((h_n' * cosine_w1).^2 + (h_n' * sine_w1).^2)/2;
squre_h_n_w2 = ((h_n' * cosine_w2).^2 + (h_n' * sine_w2).^2)/2;
objec = sum(1 - squre_h_n_w1) + sum(squre_h_n_w2);

prob = optimproblem('Objective',objec);
prob.Constraints.cons1 = sum(h_n) == sqrt(2);
prob.Constraints.cons2 = h_n(1) == h_n(8);
prob.Constraints.cons3 = h_n(2) == h_n(7);
prob.Constraints.cons4 = h_n(3) == h_n(6);
prob.Constraints.cons5 = h_n(4) == h_n(5);


problem = prob2struct(prob);
[x,fval] = quadprog(problem);