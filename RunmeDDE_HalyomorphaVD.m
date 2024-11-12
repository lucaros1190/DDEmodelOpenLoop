
% DDE script - Halyomorpha halys with temperature-dependent delays

% Created by Luca Rossini on 3 November 2023
% Last update 27 February 2024
% e-mail: luca.rossini@unitus.it

% Start to calculate the simulation time

tic

% Clearing the workspace before the beginning

clear
clc
close all


    % Chained ODE system with constant delays - Compartmental model for
    % insect life cycle representation

% Load the parameters and other inputs

run("Parameters.m")

% Load the functions from Functions.m

Fun = Functions;


% Definition of the initial conditions for the associated ODE system

InitCond_ODE = load("Parameters.mat", "InitCond_ODE");
InitCond_ODE = cell2mat(struct2cell(InitCond_ODE));

% Solve the equation - DDE system

    % Define the time span

t_span = load("Parameters.mat", "t_span");
t_span = cell2mat(struct2cell(t_span));

    % Calculate the solution using dde23

solPartial = ddesd(@(t, y, Z) Fun.ddefun_partial(t, y, Z, SR, FertPar, ...
                                   MortPar_Egg, MortPar_N1, MortPar_N2, ...
                                   MortPar_N3, MortPar_N4, MortPar_N5, ...
                                   DevRate_Egg, DevRate_N1, DevRate_N2, ...
                                   DevRate_N3, DevRate_N4, DevRate_N5, ...
                                   DevRate_Ad, DailyTemp), ...
                   @(t, y) Fun.Delays(t, y, DailyTemp, LagPar_Egg, LagPar_N1, ...
                                   LagPar_N2, LagPar_N3, LagPar_N4, ...
                                   LagPar_N5, LagPar_Am, LagPar_PreOvi,...
                                   LagPar_Amf), ...
                   @(t) Fun.history(t, InitHist_DDE), ...
                   t_span);


% Solve the associate ODE to the DDE system - to double check

[time, solODE] = ode45(@(t, y) Fun.ODEfun_partial(t, y, SR, FertPar, ...
                               MortPar_Egg, MortPar_N1, MortPar_N2, ...
                               MortPar_N3, MortPar_N4, MortPar_N5, ...
                               DevRate_Egg, DevRate_N1, DevRate_N2, ...
                               DevRate_N3, DevRate_N4, DevRate_N5, ...
                               DevRate_Ad, DailyTemp), ...
                       t_span, ...
                       InitCond_ODE);


% Plot the results by recalling the dedicated script

run("Plots.m");


% End the calculation of the simulation time

toc

