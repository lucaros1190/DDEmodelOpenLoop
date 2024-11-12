
% File that plots the results calculated in 'RunmeDDE_HalyomorphaVD.m'

% Created by Luca Rossini on 27 November 2023
% Last update 5 March 2024
% e-mail: luca.rossini@unitus.it

% Plot the solutions - General resume + state comparisons

figure

subplot(2, 2, 1)

plot(solPartial.x, solPartial.y, 'LineWidth', 1.5)
title('Partial lags DDE')
xlabel('Time')
ylabel('Population density')
legend('E(t)', 'N1(t)', 'N2(t)', 'N3(t)', 'N4(t)', 'N5(t)', 'Am(t)', ...
       'Anmf(t)', 'Amf(t)', 'Deads')

subplot(2, 2, 2)

plot(solPartial.y(1, :), solPartial.y(4, :), 'LineWidth', 1.5)
title('Partial lags DDE - Eggs vs Females')
xlabel('Eggs')
ylabel('Adult females')

subplot(2, 2, 3)

plot(time, solODE, 'LineWidth', 1.5)
title('ODE')
xlabel('Time')
ylabel('Population density')
legend('E(t)', 'N1(t)', 'N2(t)', 'N3(t)', 'N4(t)', 'N5(t)', 'Am(t)', ...
       'Anmf(t)', 'Amf(t)', 'Deads')

subplot(2, 2, 4)

plot(solODE(:, 1), solODE(:, 4), 'LineWidth', 1.5)
title('ODE - Eggs vs Females')
xlabel('Eggs')
ylabel('Adult females')


% Plot the solutions - DDE vs ODE stage by stage

figure

subplot(3, 3, 1)

hold on

plot(solPartial.x, solPartial.y(1, :), 'LineWidth', 1.5)
plot(time, solODE(:, 1), 'LineWidth', 1.5)
title('Eggs')
xlabel('Time')
ylabel('Population density')
legend('E(t) - DDE', 'E(t) - ODE')

hold off


subplot(3, 3, 2)

hold on

plot(solPartial.x, solPartial.y(2, :), 'LineWidth', 1.5)
plot(time, solODE(:, 2), 'LineWidth', 1.5)
title('Nymph 1')
xlabel('Time')
ylabel('Population density')
legend('N1(t) - DDE', 'N1(t) - ODE')

hold off


subplot(3, 3, 3)

hold on

plot(solPartial.x, solPartial.y(3, :), 'LineWidth', 1.5)
plot(time, solODE(:, 3), 'LineWidth', 1.5)
title('Nymph 2')
xlabel('Time')
ylabel('Population density')
legend('N2(t) - DDE', 'N2(t) - ODE')

hold off


subplot(3, 3, 4)

hold on

plot(solPartial.x, solPartial.y(4, :), 'LineWidth', 1.5)
plot(time, solODE(:, 4), 'LineWidth', 1.5)
title('Nymph 3')
xlabel('Time')
ylabel('Population density')
legend('N3(t) - DDE', 'N3(t) - ODE')

hold off


subplot(3, 3, 5)

hold on

plot(solPartial.x, solPartial.y(5, :), 'LineWidth', 1.5)
plot(time, solODE(:, 5), 'LineWidth', 1.5)
title('Nymph 4')
xlabel('Time')
ylabel('Population density')
legend('N4(t) - DDE', 'N4(t) - ODE')

hold off


subplot(3, 3, 6)

hold on

plot(solPartial.x, solPartial.y(6, :), 'LineWidth', 1.5)
plot(time, solODE(:, 6), 'LineWidth', 1.5)
title('Nymph 5')
xlabel('Time')
ylabel('Population density')
legend('N5(t) - DDE', 'N5(t) - ODE')

hold off


subplot(3, 3, 7)

hold on

plot(solPartial.x, solPartial.y(7, :), 'LineWidth', 1.5)
plot(time, solODE(:, 7), 'LineWidth', 1.5)
title('Adult males')
xlabel('Time')
ylabel('Population density')
legend('Am(t) - DDE', 'Am(t) - ODE')

hold off


subplot(3, 3, 8)

hold on

plot(solPartial.x, solPartial.y(8, :), 'LineWidth', 1.5)
plot(time, solODE(:, 8), 'LineWidth', 1.5)
title('Adult non mated females')
xlabel('Time')
ylabel('Population density')
legend('Anmf(t) - DDE', 'Anmf(t) - ODE')

hold off


subplot(3, 3, 9)

hold on

plot(solPartial.x, solPartial.y(9, :), 'LineWidth', 1.5)
plot(time, solODE(:, 9), 'LineWidth', 1.5)
title('Adult mated females')
xlabel('Time')
ylabel('Population density')
legend('Amf(t) - DDE', 'Amf(t) - ODE')

hold off


% Plot the solutions - ODE vs DDE + mortality

figure

subplot(2, 1, 1)

hold on

plot(solPartial.x, solPartial.y(1, :), 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(2, :), 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(3, :), 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(4, :), 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(5, :), 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(6, :), 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(7, :), '-.', 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(8, :), '-.', 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(9, :), '-.', 'LineWidth', 1.5)
plot(solPartial.x, solPartial.y(10, :), '-.', 'LineWidth', 1.5)
title('Partial lags DDE')
xlabel('Time')
ylabel('Population density')
legend('E(t)', 'N1(t)', 'N2(t)', 'N3(t)', 'N4(t)', 'N5(t)', 'Am(t)', ...
       'Anmf(t)', 'Amf(t)', 'Deads')

hold off

subplot(2, 1, 2)

hold on

plot(time, solODE(:, 1), 'LineWidth', 1.5)
plot(time, solODE(:, 2), 'LineWidth', 1.5)
plot(time, solODE(:, 3), 'LineWidth', 1.5)
plot(time, solODE(:, 4), 'LineWidth', 1.5)
plot(time, solODE(:, 5), 'LineWidth', 1.5)
plot(time, solODE(:, 6), 'LineWidth', 1.5)
plot(time, solODE(:, 7), '-.', 'LineWidth', 1.5)
plot(time, solODE(:, 8), '-.', 'LineWidth', 1.5)
plot(time, solODE(:, 9), '-.', 'LineWidth', 1.5)
plot(time, solODE(:, 10), '-.', 'LineWidth', 1.5)
title('ODE')
xlabel('Time')
ylabel('Population density')
legend('E(t)', 'N1(t)', 'N2(t)', 'N3(t)', 'N4(t)', 'N5(t)', 'Am(t)', ...
       'Anmf(t)', 'Amf(t)', 'Deads')

hold off


% Plot the solutions of adults: ODE and DDE vs Experimental data - Note
% that here we consider the whole ADULT populations, because we are not
% distinguishing in the case of H. halys!

TotAdultsDDE = solPartial.y(7, :) + solPartial.y(8, :) + solPartial.y(9, :);
TotAdultsODE = solODE(:, 7) + solODE(:, 8) + solODE(:, 9);

figure

subplot(2, 1, 1)

hold on

plot(solPartial.x, TotAdultsDDE, 'LineWidth', 1.5)
plot(ExpDataDay, ExpDataAdults, '*','LineWidth', 1.5)

title('DDE model')
xlabel('Time')
ylabel('Population density')
legend('Tot Adults - DDE', 'Exp adults')

hold off


subplot(2, 1, 2)

hold on

plot(time, TotAdultsODE, 'LineWidth', 1.5)
scatter(ExpDataDay, ExpDataAdults, 'Marker', '*');
title('ODE model')
xlabel('Time')
ylabel('Population density')
legend('Tot Adults - ODE', 'Exp adults')

hold off


% Plot the solutions of adults: ODE and DDE vs Experimental data - Note
% that here we consider the population of NYMPHS

TotNymphsDDE = solPartial.y(6, :);
TotNymphsODE = solODE(:, 6);

figure

subplot(2, 1, 1)

hold on

plot(solPartial.x, TotNymphsDDE, 'LineWidth', 1.5)
scatter(ExpDataDay, ExpDataNymphs, 'Marker', '*')
title('DDE model')
xlabel('Time')
ylabel('Population density')
legend('Tot nymphs - DDE', 'Exp nymphae')

hold off


subplot(2, 1, 2)

hold on

plot(time, TotNymphsODE, 'LineWidth', 1.5)
scatter(ExpDataDay, ExpDataNymphs, 'Marker', '*')
title('ODE model')
xlabel('Time')
ylabel('Population density')
legend('Tot nymphs - ODE', 'Exp nymphae')

hold off


% Plot the solutions of adults and nymphae: ODE and DDE vs Experimental 
% data

figure

subplot(2, 1, 1)

hold on

plot(solPartial.x, TotNymphsDDE, 'LineWidth', 1.5)
scatter(ExpDataDay, ExpDataNymphs, 'Marker', '*')
title('DDE model - Nymphae')
xlabel('Time (days)')
ylabel('Population density')
legend('Sim nymphae', 'Exp nymphae')

hold off


subplot(2, 1, 2)

hold on

plot(solPartial.x, TotAdultsDDE, 'LineWidth', 1.5)
scatter(ExpDataDay, ExpDataAdults, 'Marker', '*')
title('DDE model - Adults')
xlabel('Time (days)')
ylabel('Population density')
legend('Sim adults', 'Exp adults')

hold off
