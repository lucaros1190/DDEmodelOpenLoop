
% File containing all the parameters needed by 'RunmeDDE_HalyomorphaVD.m'
% Change here the parameters and run directly 'RunmeDDE_HalyomorphaVD.m'

% Created by Luca Rossini on 3 November 2023
% Last update 16 November 2023
% E-mail: luca.rossini@unitus.it


% Absorb the temperature array

InputFile = xlsread('TemperatureInput.xlsx');
DailyTemp = InputFile(:, 3);


% Absorb the experimental data for plotting purpose

ExpDataFile = xlsread('ExperimentalData.xlsx');
ExpDataDay = ExpDataFile(:, 2);
ExpDataNymphs = ExpDataFile(:, 3);
ExpDataAdults = ExpDataFile(:, 4);


% Define the time span

t_span = [0, length(DailyTemp)];


% Equation parameters

    % Sex ratio

SR = 0.5;

    % Fertility

alpha = 74968.6851351;
gamma = 10.0000002;
lambda = 21.1615365;
delta = 5.0865985;
tau = 25.0653308;

FertPar = [alpha gamma lambda delta tau];

    % Mortality - EGGS

a_e = 0.0001667;
b_e = -0.0162653;
c_e = 0.5844314;
d_e = -9.163731;
e_e = 52.9093736;

MortPar_Egg = [a_e b_e c_e d_e e_e];

    % Mortality - N1

a_N1 = 3.01e-05;
b_N1 = -0.003706;
c_N1 = 0.1668317;
d_N1 = -3.2539274;
e_N1 = 23.2205487;

MortPar_N1 = [a_N1 b_N1 c_N1 d_N1 e_N1];

    % Mortality - N2

a_N2 = 5.9e-05;
b_N2 = -0.0057541;
c_N2 = 0.2135545;
d_N2 = -3.5937791;
e_N2 = 23.3620976;

MortPar_N2 = [a_N2 b_N2 c_N2 d_N2 e_N2];

    % Mortality - N3

a_N3 = 0.0001129;
b_N3 = -0.0113512;
c_N3 = 0.4254478;
d_N3 = -7.0417152;
e_N3 = 43.5214056;

MortPar_N3 = [a_N3 b_N3 c_N3 d_N3 e_N3];

    % Mortality - N4

a_N4 = 0.000156;
b_N4 = -0.015777;
c_N4 = 0.591451;
d_N4 = -9.7212598;
e_N4 = 59.0601027;

MortPar_N4 = [a_N4 b_N4 c_N4 d_N4 e_N4];

    % Mortality - N5

a_N5 = 6.24e-05;
b_N5 = -0.006405;
c_N5 = 0.2495236;
d_N5 = -4.3471306;
e_N5 = 28.4991245;

MortPar_N5 = [a_N5 b_N5 c_N5 d_N5 e_N5];

    % Development - EGGS
    
a_Egg = 0.000238;
T_L_Egg = 11.03;
T_M_Egg = 38;
m_Egg = 2.812;

DevRate_Egg = [a_Egg T_L_Egg T_M_Egg m_Egg];

    % Development - N1

a_N1 = 0.000198;
T_L_N1 = 13.79;
T_M_N1 = 39.41;
m_N1 = 1.892;

DevRate_N1 = [a_N1 T_L_N1 T_M_N1 m_N1];

    % Development - N2

a_N2 = 0.0002009;
T_L_N2 = 7.299;
T_M_N2 = 36.01;
m_N2 = 15.32;

DevRate_N2 = [a_N2 T_L_N2 T_M_N2 m_N2];

    % Development - N3

a_N3 = 0.00004836;
T_L_N3 = 14.28;
T_M_N3 = 39.93;
m_N3 = 1.106;

DevRate_N3 = [a_N3 T_L_N3 T_M_N3 m_N3];

    % Development - N4    

a_N4 = 0.00008691;
T_L_N4 = 7.464;
T_M_N4 = 38.98;
m_N4 = 2.011; 

DevRate_N4 = [a_N4 T_L_N4 T_M_N4 m_N4];

    % Development - N5

a_N5 = 0.00004418;
T_L_N5 = 9.265;
T_M_N5 = 39.99;
m_N5 = 1.49;

DevRate_N5 = [a_N5 T_L_N5 T_M_N5 m_N5];

    % Development - Adult

a_Ad = 0.00002012;
T_L_Ad = 11.0;
T_M_Ad = 39.97;
m_Ad = 2.097;

DevRate_Ad = [a_Ad T_L_Ad T_M_Ad m_Ad];


% Initial conditions - ODE

InitCond_ODE = [0,      % Egg
                0,      % N1
                0,      % N2
                0,      % N3
                0,      % N4
                0,      % N5
                20,      % Adult males
                0,      % Non mated females
                30,      % Mated females
                0];     % Dead


% Initial history - DDE

InitHist_DDE = [0,      % Egg
                0,      % N1
                0,      % N2
                20,      % N3
                0,      % N4
                0,      % N5
                0,      % Adult males
                0,      % Non mated females
                1,      % Mated females
                0];     % Dead


% Lag functions parameters - for DDE model

% ATTENTION PLEASE: if you change the parameters because you want to apply
% this code to a different species, check the if/else filters into the
% specific lag functions!

    % Egg lag

a_Egg = 0.917942;
b_Egg = -57.757927;
c_Egg = 984.505134;
d_Egg = 1.711403;

LagPar_Egg = [a_Egg b_Egg c_Egg d_Egg];

    % N1 lag

a_N1 = -0.048521;
b_N1 = 2.064456;
c_N1 = 28.760370;
d_N1 = -12.939449;

LagPar_N1 = [a_N1 b_N1 c_N1 d_N1];

    % N2 lag

a_N2 = 64.011770;
b_N2 = -0.086601;

LagPar_N2 = [a_N2 b_N2];

    % N3 lag

a_N3 = -0.044249;
b_N3 = 2.357864;
c_N3 = -27.126639;

LagPar_N3 = [a_N3 b_N3 c_N3];

    % N4 lag

a_N4 = 0.002183;
b_N4 = -0.179449;
c_N4 = 4.514058;
d_N4 = -29.120932;

LagPar_N4 = [a_N4 b_N4 c_N4 d_N4];

    % N5 lag

a_N5 = -2.834640;
b_N5 = 250.842032;
c_N5 = 1.626221;

LagPar_N5 = [a_N5 b_N5 c_N5];

    % Adult non mated females lag - Preoviposition period!

a_PreOvi = 7.0e+15;
b_PreOvi = -11.147985;
c_PreOvi = 10.613228;

LagPar_PreOvi = [a_PreOvi b_PreOvi c_PreOvi];

    % Adult males and females - Fake lag of one day just for calculation
    % purposes. This assumes that they females and males have to wait one
    % day before developing

LagPar_Am = 1;
LagPar_Amf = 1;


% Create the .mat file containing all the parameters

delete("Parameters.mat")
save Parameters.mat t_span InitCond_ODE ExpDataFile ExpDataNymphs ...
     ExpDataAdults ExpDataDay
