
% Fitting the minimum delays over temperature from life tables data of H.
% halys

% Created by Luca Rossini on 7 November 2023
% Last update 16 November 2023
% E-mail: luca.rossini@unitus.it

clear
clc
close all

% Acquisition of the life tables data - File 'LifeTablesDataset.xlsx'

Temperature = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'A3:A11');
TemperatureShort = Temperature(2 : end);

AvgTime_Egg = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'B3:B11');
StErrTime_Egg = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                        'C3:C11');


AvgTime_N1 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'D3:D11');
StErrTime_N1 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                       'E3:E11');


AvgTime_N2 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'F3:F11');
StErrTime_N2 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                       'G3:G11');


AvgTime_N3 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'H3:H11');
StErrTime_N3 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                       'I3:I11');


AvgTime_N4 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'J3:J11');
StErrTime_N4 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                       'K3:K11');

AvgTime_N5 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                      'L3:L11');
StErrTime_N5 = xlsread('LifeTablesDataset.xlsx', 'Development-Govindan', ...
                       'M3:M11');

NumberInsectReared = xlsread('LifeTablesDataset.xlsx', 'Delays', ...
                       'B10:B18');

Temp_PreOvipoPeriod = xlsread('LifeTablesDataset.xlsx', 'Delays', ...
                       'K23:K27');

PreOvipoPeriod = xlsread('LifeTablesDataset.xlsx', 'Delays', ...
                       'L23:L27');

Err_PreOvipoPeriod = xlsread('LifeTablesDataset.xlsx', 'Delays', ...
                       'M23:M27');

% Calculation of the standard deviations based on the number of individuals
% reared, N, and the standard errors of the times

DevSt_Egg = times(StErrTime_Egg, realpow(NumberInsectReared, 1/2));
DevSt_N1 = times(StErrTime_N1, realpow(NumberInsectReared, 1/2));
DevSt_N2 = times(StErrTime_N2, realpow(NumberInsectReared(2:end), 1/2));
DevSt_N3 = times(StErrTime_N3, realpow(NumberInsectReared(2:end), 1/2));
DevSt_N4 = times(StErrTime_N4, realpow(NumberInsectReared(2:end), 1/2));
DevSt_N5 = times(StErrTime_N5, realpow(NumberInsectReared(2:end), 1/2));


% Calculation of the minimum delays according to the standard error and the
% expected values usually published in the life tables works

Delay_Egg = AvgTime_Egg - times(2, DevSt_Egg);
Delay_N1 = AvgTime_N1 - times(2, DevSt_N1);
Delay_N2 = AvgTime_N2 - times(2, DevSt_N2);
Delay_N3 = AvgTime_N3 - times(2, DevSt_N3);
Delay_N4 = AvgTime_N4 - times(1, DevSt_N4);
Delay_N5 = AvgTime_N5 - times(2, DevSt_N5);


% Fitting the EGG delays over temperature - The candidate function is the
% result of different attempts with the data. There is no reason to prefer
% one instead of the other, if not based on the fitting performance.

    % Define the function to be fitted

EggDelayFun = '(a * x^2 + b * x + c) / (x + d)';

    % Initial conditions and boundaries for fitting:
    % 'a, b, c, d' is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

EggInitCond = [ ];
EggLowBound = [ ];
EggUpBound = [ ];

EggDelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                            'Lower', EggLowBound, 'Upper', EggUpBound, ...
                            'StartPoint', EggInitCond);

    % Fitting algorithm and solution storage

[EggDelayFit, EggDelaygof] = fit(Temperature, Delay_Egg, EggDelayFun, ...
                                 EggDelayFitOpt);

    % Save the coeffiecient values for a, b, c, and d in a vector

EggDelayFitRes = coeffvalues(EggDelayFit);

    % Get the confidence interval

CI_Egg = confint(EggDelayFit, 0.8);

    % Chi square test for the goodness of fit

FitData_Egg = EggDelayFit(Temperature);
BinsEgg = 0 : (length(Delay_Egg) - 1);

[h_Egg, p_Egg, st_Egg] = chi2gof(BinsEgg, 'Ctrs', BinsEgg, ...
                                 'Frequency', Delay_Egg, ...
                                 'Expected', FitData_Egg);

    % Print results on the console

fprintf('\n EGG delay over temperature - Fit Results: \n\n')
fprintf('a = %f +/- %f\n', EggDelayFitRes(1), ...
                           abs((CI_Egg(1) - CI_Egg(2)) / 5.15))
fprintf('b = %f +/- %f\n', EggDelayFitRes(2), ...
                           abs((CI_Egg(3) - CI_Egg(4)) / 5.15))
fprintf('c = %f +/- %f\n', EggDelayFitRes(3), ...
                           abs((CI_Egg(5) - CI_Egg(6)) / 5.15))
fprintf('d = %f +/- %f\n', EggDelayFitRes(4), ...
                           abs((CI_Egg(7) - CI_Egg(8)) / 5.15))

fprintf('\n Goodness of fit:\n')
EggDelaygof

fprintf('\n Chi squared test:\n')
h_Egg
p_Egg
st_Egg


% Fitting the N1 delays over temperature - The candidate function is the
% result of different attempts with the data. There is no reason to prefer
% one instead of the other, if not based on the fitting performance.

    % Define the function to be fitted

N1DelayFun = '(a * x^2 + b * x + c) / (x + d)';

    % Initial conditions and boundaries for fitting:
    % 'a, b, c, d' is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

N1InitCond = [-0.04 2.0 28 -12];
N1LowBound = [ ];
N1UpBound = [ ];

N1DelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                           'Lower', N1LowBound, 'Upper', N1UpBound, ...
                           'StartPoint', N1InitCond);

    % Fitting algorithm and solution storage

[N1DelayFit, N1Delaygof] = fit(Temperature, Delay_N1, N1DelayFun, ...
                                 N1DelayFitOpt);

    % Save the coeffiecient values for a, b, c, and d in a vector

N1DelayFitRes = coeffvalues(N1DelayFit);

    % Get the confidence interval

CI_N1 = confint(N1DelayFit, 0.95);

    % Chi square test for the goodness of fit

FitData_N1 = N1DelayFit(Temperature);
BinsN1 = 0 : (length(Delay_N1) - 1);

[h_N1, p_N1, st_N1] = chi2gof(BinsN1, 'Ctrs', BinsN1, ...
                                 'Frequency', Delay_N1, ...
                                 'Expected', FitData_N1);

    % Print results on the console

fprintf('\n N1 delay over temperature - Fit Results: \n\n')
fprintf('a = %f +/- %f\n', N1DelayFitRes(1), ...
                           abs((CI_N1(1) - CI_N1(2)) / 5.15))
fprintf('b = %f +/- %f\n', N1DelayFitRes(2), ...
                           abs((CI_N1(3) - CI_N1(4)) / 5.15))
fprintf('c = %f +/- %f\n', N1DelayFitRes(3), ...
                           abs((CI_N1(5) - CI_N1(6)) / 5.15))
fprintf('d = %f +/- %f\n', N1DelayFitRes(4), ...
                           abs((CI_N1(7) - CI_N1(8)) / 5.15))

fprintf('\n Goodness of fit:\n')
N1Delaygof

fprintf('\n Chi squared test:\n')
h_N1
p_N1
st_N1


% Fitting the N2 delays over temperature - The candidate function is the
% result of different attempts with the data. There is no reason to prefer
% one instead of the other, if not based on the fitting performance.

    % Define the function to be fitted

N2DelayFun = 'a * exp(b * x)';

    % Initial conditions and boundaries for fitting:
    % 'a, b is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

N2InitCond = [ ];
N2LowBound = [ ];
N2UpBound = [ ];

N2DelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                           'Lower', N2LowBound, 'Upper', N2UpBound, ...
                           'StartPoint', N2InitCond);

    % Fitting algorithm and solution storage

[N2DelayFit, N2Delaygof] = fit(TemperatureShort, Delay_N2, N2DelayFun, ...
                                 N2DelayFitOpt);

    % Save the coeffiecient values for a and b in a vector

N2DelayFitRes = coeffvalues(N2DelayFit);

    % Get the confidence interval

CI_N2 = confint(N2DelayFit, 0.95);

    % Chi square test for the goodness of fit

FitData_N2 = N2DelayFit(TemperatureShort);
BinsN2 = 0 : (length(Delay_N2) - 1);

[h_N2, p_N2, st_N2] = chi2gof(BinsN2, 'Ctrs', BinsN2, ...
                                 'Frequency', Delay_N2, ...
                                 'Expected', FitData_N2);

    % Print results on the console

fprintf('\n N2 delay over temperature - Fit Results: \n\n')
fprintf('a = %f +/- %f\n', N2DelayFitRes(1), ...
                           abs((CI_N2(1) - CI_N2(2)) / 3.96))
fprintf('b = %f +/- %f\n', N2DelayFitRes(2), ...
                           abs((CI_N2(3) - CI_N2(4)) / 3.96))

fprintf('\n Goodness of fit:\n')
N2Delaygof

fprintf('\n Chi squared test:\n')
h_N2
p_N2
st_N2


% Fitting the N3 delays over temperature - The candidate function is the
% result of different attempts with the data. There is no reason to prefer
% one instead of the other, if not based on the fitting performance.

    % Define the function to be fitted

N3DelayFun = 'a * x^2 + b * x + c';

    % Initial conditions and boundaries for fitting:
    % 'a, b, c is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

N3InitCond = [ ];
N3LowBound = [ ];
N3UpBound = [ ];

N3DelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                           'Lower', N3LowBound, 'Upper', N3UpBound, ...
                           'StartPoint', N3InitCond);

    % Fitting algorithm and solution storage

[N3DelayFit, N3Delaygof] = fit(TemperatureShort, Delay_N3, N3DelayFun, ...
                                 N3DelayFitOpt);

    % Save the coeffiecient values for a and b in a vector

N3DelayFitRes = coeffvalues(N3DelayFit);

    % Get the confidence interval

CI_N3 = confint(N3DelayFit, 0.95);

    % Chi square test for the goodness of fit

FitData_N3 = N3DelayFit(TemperatureShort);
BinsN3 = 0 : (length(Delay_N3) - 1);

[h_N3, p_N3, st_N3] = chi2gof(BinsN3, 'Ctrs', BinsN3, ...
                                 'Frequency', Delay_N3, ...
                                 'Expected', FitData_N3);

    % Print results on the console

fprintf('\n N3 delay over temperature - Fit Results: \n\n')
fprintf('a = %f +/- %f\n', N3DelayFitRes(1), ...
                           abs((CI_N3(1) - CI_N3(2)) / 3.96))
fprintf('b = %f +/- %f\n', N3DelayFitRes(2), ...
                           abs((CI_N3(3) - CI_N3(4)) / 3.96))
fprintf('c = %f +/- %f\n', N3DelayFitRes(3), ...
                           abs((CI_N3(5) - CI_N3(6)) / 3.96))

fprintf('\n Goodness of fit:\n')
N3Delaygof

fprintf('\n Chi squared test:\n')
h_N3
p_N3
st_N3


% Fitting the N4 delays over temperature - The candidate function is the
% result of different attempts with the data. There is no reason to prefer
% one instead of the other, if not based on the fitting performance.

    % Define the function to be fitted

N4DelayFun = 'a * x^3 + b * x^2 + c * x + d';

    % Initial conditions and boundaries for fitting:
    % 'a, b, c, d is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

N4InitCond = [ ];
N4LowBound = [ ];
N4UpBound = [ ];

N4DelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                           'Lower', N4LowBound, 'Upper', N4UpBound, ...
                           'StartPoint', N4InitCond);

    % Fitting algorithm and solution storage

[N4DelayFit, N4Delaygof] = fit(TemperatureShort, Delay_N4, N4DelayFun, ...
                                 N4DelayFitOpt);

    % Save the coeffiecient values for a and b in a vector

N4DelayFitRes = coeffvalues(N4DelayFit);

    % Get the confidence interval

CI_N4 = confint(N4DelayFit, 0.95);

    % Chi square test for the goodness of fit

FitData_N4 = N4DelayFit(TemperatureShort);
BinsN4 = 0 : (length(Delay_N4) - 1);

[h_N4, p_N4, st_N4] = chi2gof(BinsN4, 'Ctrs', BinsN4, ...
                                 'Frequency', Delay_N4, ...
                                 'Expected', FitData_N4);

    % Print results on the console

fprintf('\n N4 delay over temperature - Fit Results: \n\n')
fprintf('a = %f +/- %f\n', N4DelayFitRes(1), ...
                           abs((CI_N4(1) - CI_N4(2)) / 3.96))
fprintf('b = %f +/- %f\n', N4DelayFitRes(2), ...
                           abs((CI_N4(3) - CI_N4(4)) / 3.96))
fprintf('c = %f +/- %f\n', N4DelayFitRes(3), ...
                           abs((CI_N4(5) - CI_N4(6)) / 3.96))
fprintf('d = %f +/- %f\n', N4DelayFitRes(4), ...
                           abs((CI_N4(7) - CI_N4(8)) / 3.96))

fprintf('\n Goodness of fit:\n')
N4Delaygof

fprintf('\n Chi squared test:\n')
h_N4
p_N4
st_N4


% Fitting the N5 delays over temperature - The candidate function is the
% result of different attempts with the data. There is no reason to prefer
% one instead of the other, if not based on the fitting performance.

    % Define the function to be fitted

N5DelayFun = '(a * x + b) / (x + c)';

    % Initial conditions and boundaries for fitting:
    % 'a, b, c' is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

N5InitCond = [ ];
N5LowBound = [ ];
N5UpBound = [ ];

N5DelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                           'Lower', N5LowBound, 'Upper', N5UpBound, ...
                           'StartPoint', N5InitCond);

    % Fitting algorithm and solution storage

[N5DelayFit, N5Delaygof] = fit(TemperatureShort, Delay_N5, N5DelayFun, ...
                                 N5DelayFitOpt);

    % Save the coeffiecient values for a, b, and c in a vector

N5DelayFitRes = coeffvalues(N5DelayFit);

CI_N5 = confint(N5DelayFit, 0.95);

    % Chi square test for the goodness of fit

FitData_N5 = N5DelayFit(TemperatureShort);
BinsN5 = 0 : (length(Delay_N5) - 1);

[h_N5, p_N5, st_N5] = chi2gof(BinsN5, 'Ctrs', BinsN5, ...
                                 'Frequency', Delay_N5, ...
                                 'Expected', FitData_N5);

    % Print results on the console

fprintf('\n N5 delay over temperature - Fit Results: \n\n')
fprintf('a = %f +/- %f\n', N5DelayFitRes(1), ...
                           abs((CI_N5(1) - CI_N5(2)) / 3.96))
fprintf('b = %f +/- %f\n', N5DelayFitRes(2), ...
                           abs((CI_N5(3) - CI_N5(4)) / 3.96))
fprintf('c = %f +/- %f\n', N5DelayFitRes(3), ...
                           abs((CI_N5(5) - CI_N5(6)) / 3.96))

fprintf('\n Goodness of fit:\n')
N5Delaygof

fprintf('\n Chi squared test:\n')
h_N5
p_N5
st_N5


% Fitting the Preoviposition delays over temperature - The candidate 
% function is the result of different attempts with the data. There is no 
% reason to prefer one instead of the other, if not based on the fitting 
% performance.

    % Define the function to be fitted

PreOvipDelayFun = 'a * x^b + c';

    % Initial conditions and boundaries for fitting:
    % 'a, b, c' is the order in the arrays. Leave empty if you don't
    % need and it goes in open loop.

PreOvipInitCond = [7e+15 -10 10];
PreOvipLowBound = [ ];
PreOvipUpBound = [ ];

PreOvipDelayFitOpt = fitoptions('Method', 'NonlinearLeastSquares', ...
                                'Lower', PreOvipLowBound, ...
                                'Upper', PreOvipUpBound, ...
                                'StartPoint', PreOvipInitCond);

    % Fitting algorithm and solution storage

[PreOvipDelayFit, PreOvipDelaygof] = fit(Temp_PreOvipoPeriod, ...
                                        PreOvipoPeriod, PreOvipDelayFun, ...
                                        PreOvipDelayFitOpt);

    % Save the coeffiecient values for a, b, and c in a vector

PreOvipDelayFitRes = coeffvalues(PreOvipDelayFit);

CI_PreOvip = confint(PreOvipDelayFit, 0.95);

    % Chi square test for the goodness of fit

FitData_PreOvip = PreOvipDelayFit(Temp_PreOvipoPeriod);
BinsPreOvip = 0 : (length(PreOvipoPeriod) - 1);

[h_PreOvip, p_PreOvip, st_PreOvip] = chi2gof(BinsPreOvip, 'Ctrs', ...
                                            BinsPreOvip, 'Frequency', ...
                                            PreOvipoPeriod, 'Expected', ...
                                            FitData_PreOvip);

    % Print results on the console

fprintf(['\n Pre-oviposition period delay over temperature - ' ...
         'Fit Results: \n\n'])
fprintf('a = %f +/- %f\n', PreOvipDelayFitRes(1), ...
                           abs((CI_PreOvip(1) - CI_PreOvip(2)) / 3.96))
fprintf('b = %f +/- %f\n', PreOvipDelayFitRes(2), ...
                           abs((CI_PreOvip(3) - CI_PreOvip(4)) / 3.96))
fprintf('c = %f +/- %f\n', PreOvipDelayFitRes(3), ...
                           abs((CI_PreOvip(5) - CI_PreOvip(6)) / 3.96))

fprintf('\n Goodness of fit:\n')
PreOvipDelaygof

fprintf('\n Chi squared test:\n')
h_PreOvip
p_PreOvip
st_PreOvip


% Plot the delays over temperature - Raw data altogether

figure

hold on

plot(Temperature, Delay_Egg, 'LineWidth', 1.5)
plot(Temperature, Delay_N1, 'LineWidth', 1.5)
plot(Temperature(2:end), Delay_N2, 'LineWidth', 1.5)
plot(Temperature(2:end), Delay_N3, 'LineWidth', 1.5)
plot(Temperature(2:end), Delay_N4, 'LineWidth', 1.5)
plot(Temperature(2:end), Delay_N5, 'LineWidth', 1.5)
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
title('Experimental delays over temperature')
legend('Egg', 'N1', 'N2', 'N3', 'N4', 'N5')


% Plot the raw data and the best fit functions 

    % Definition of the temperature range - For plotting purposes

TempPlot = linspace(14, 40, 27);

    % Definition of the subplots

figure

        % Egg

subplot(3, 2, 1)

hold on

scatter(Temperature, Delay_Egg, 'o', 'filled', 'blue')
plot(TempPlot, EggDelayFit(TempPlot), 'red', 'LineWidth', 1.5)
title('Egg minimum delay')
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
legend('Exp data', 'Best fit function')

hold off

        % N1

subplot(3, 2, 2)

hold on

scatter(Temperature, Delay_N1, 'o', 'filled', 'blue')
plot(TempPlot, N1DelayFit(TempPlot), 'red', 'LineWidth', 1.5)
title('N1 minimum delay')
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
legend('Exp data', 'Best fit function')

hold off

        % N2

subplot(3, 2, 3)

hold on

scatter(TemperatureShort, Delay_N2, 'o', 'filled', 'blue')
plot(TempPlot, N2DelayFit(TempPlot), 'red', 'LineWidth', 1.5)
title('N2 minimum delay')
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
legend('Exp data', 'Best fit function')

hold off

        % N3

subplot(3, 2, 4)

hold on

scatter(TemperatureShort, Delay_N3, 'o', 'filled', 'blue')
plot(TempPlot, N3DelayFit(TempPlot), 'red', 'LineWidth', 1.5)
title('N3 minimum delay')
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
legend('Exp data', 'Best fit function')

hold off

        % N4

subplot(3, 2, 5)

hold on

scatter(TemperatureShort, Delay_N4, 'o', 'filled', 'blue')
plot(TempPlot, N4DelayFit(TempPlot), 'red', 'LineWidth', 1.5)
title('N4 minimum delay')
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
legend('Exp data', 'Best fit function')

hold off

        % N5

subplot(3, 2, 6)

hold on

scatter(TemperatureShort, Delay_N5, 'o', 'filled', 'blue')
plot(TempPlot, N5DelayFit(TempPlot), 'red', 'LineWidth', 1.5)
title('N5 minimum delay')
xlabel('Temperature (°C)')
ylabel('Minimum delay (days)')
legend('Exp data', 'Best fit function')

hold off

% Plot of the variances over temperature

figure

hold on

plot(Temperature, DevSt_Egg, 'LineWidth', 1.5)
plot(Temperature, DevSt_N1, 'LineWidth', 1.5)
plot(Temperature(2:end), DevSt_N2, 'LineWidth', 1.5)
plot(Temperature(2:end), DevSt_N3, 'LineWidth', 1.5)
plot(Temperature(2:end), DevSt_N4, 'LineWidth', 1.5)
plot(Temperature(2:end), DevSt_N5, 'LineWidth', 1.5)
xlabel('Temperature (°C)')
ylabel('Standard deviations')
title('Standard deviation over temperature')
legend('Egg', 'N1', 'N2', 'N3', 'N4', 'N5')

% Plot the preoviposition period over temperature

figure

hold on

errorbar(Temp_PreOvipoPeriod, PreOvipoPeriod, Err_PreOvipoPeriod, ...
         '.', 'MarkerSize', 10)
plot(TempPlot, PreOvipDelayFit(TempPlot), 'red', 'LineWidth', 1.5)
ylim([0 20])
title('Preoviposition delay')
xlabel('Temperature (°C)')
ylabel('Delay (days)')
legend('Exp data', 'Best fit function')

hold off

