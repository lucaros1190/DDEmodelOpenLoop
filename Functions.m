
% Definition of the functions contained in the RunmeDDE_HalyomorphaVD.m 
% file

% Created by Luca Rossini on 3 November 2023
% Last update 29 February 2024
% E-mail: luca.rossini@unitus.it


classdef Functions

    methods (Static) % Insert any function in between "methods" and "end"


    % Temperature reader

        function Temp = TempFunction(time, TempArray)
            
            % This if/else statement is needed because there is a problem
            % when time is 0, because it goes to read the array in the 0
            % position while Matlab starts to count from 1

            if time <= 0
                Temp = TempArray(1);
            else
                Temp = TempArray(time);
            end 
        end


    % Delay function 1 - Rude interpolation of the minimum delays case of
    % the Egg and N1

    function Delay = DelayFun_EggN1(T, Parameters)

        Delay = (Parameters(1) * T^2 + Parameters(2) * T + ...
                   Parameters(3)) / (T + Parameters(4));

        if Delay <= 0
            Delay = 1;
            
        elseif T <= 15 % If out of the lower threshold

            T = 15;
            Delay = (Parameters(1) * T^2 + Parameters(2) * T + ...
                        Parameters(3)) / (T + Parameters(4));

        else
            Delay = (Parameters(1) * T^2 + Parameters(2) * T + ...
                   Parameters(3)) / (T + Parameters(4));
        end
        
    end


    % Delay function 2 - Rude interpolation of the minimum delays case of
    % the N2

    function Delay = DelayFun_N2(T, Parameters)

        Delay = Parameters(1) * exp(Parameters(2) * T);

        if Delay <= 0
            Delay = 1;

        elseif T <= 15 % If out of the lower threshold

            T = 15;
            Delay = Parameters(1) * exp(Parameters(2) * T);

        else
            Delay = Parameters(1) * exp(Parameters(2) * T);
        end
    end


    % Delay function 3 - Rude interpolation of the minimum delays case of
    %  the N3

    function Delay = DelayFun_N3(T, Parameters)

        Delay = Parameters(1) * T^2 + Parameters(2) * T + Parameters(3);

        if Delay <= 0
            Delay = 1;
        else
            Delay = Parameters(1) * T^2 + Parameters(2) * T ...
                    + Parameters(3);
        end
    end


    % Delay function 4 - Rude interpolation of the minimum delays case of
    %  the N4

    function Delay = DelayFun_N4(T, Parameters)

        Delay = Parameters(1) * T^3 + Parameters(2) * T^2 + ...
                 Parameters(3) * T + Parameters(4);

        if Delay <= 0
            Delay = 1;
        else
            Delay = Parameters(1) * T^3 + Parameters(2) * T^2 + ...
                     Parameters(3) * T + Parameters(4);
        end
    end


    % Delay function 5 - Rude interpolation of the minimum delays case of
    %  the N5

    function Delay = DelayFun_N5(T, Parameters)

        Delay = (Parameters(1) * T + Parameters(2)) / (T + Parameters(3));

        if Delay <= 0
            Delay = 1;
        else
            Delay = (Parameters(1) * T + Parameters(2)) / ...
                     (T + Parameters(3));
        end
    end


    % Delay function 6 - Rude interpolation of the preoviposition period

    function Delay = DelayFun_PreOvi(T, Parameters)

        Delay = Parameters(1) * T^Parameters(2) + Parameters(3);

        if Delay <= 0
            Delay = 1;
        else
            Delay = Parameters(1) * T^Parameters(2) + Parameters(3);
        end
    end


    % Temperature-dependent delays - To feed the DDE

    function Del = Delays(t, ~, TempArray, LagPar_Egg, LagPar_N1, ...
                          LagPar_N2, LagPar_N3, LagPar_N4, LagPar_N5, ...
                          LagPar_Am, LagPar_PreOvi, LagPar_Amf)

            % Import the parameters and functions

            F = Functions;

            % Manage time and temperatures

            time = int32(t);
            DayTemp = F.TempFunction(time, TempArray);

            tau_e = t - F.DelayFun_EggN1(DayTemp, LagPar_Egg);  % Eggs lag
            tau_N1 = t - F.DelayFun_EggN1(DayTemp, LagPar_N1); % N1 lag
            tau_N2 = t - F.DelayFun_N2(DayTemp, LagPar_N2); % N2 lag
            tau_N3 = t - F.DelayFun_N3(DayTemp, LagPar_N3); % N3 lag
            tau_N4 = t - F.DelayFun_N4(DayTemp, LagPar_N4); % N4 lag
            tau_N5 = t - F.DelayFun_N5(DayTemp, LagPar_N5); % N5 lag
            tau_Am = t - LagPar_Am(1);       % Males lag - There is no lag
            tau_Anmf = t - F.DelayFun_PreOvi(DayTemp, LagPar_PreOvi);   
                                            % Female mating lag
            tau_Amf = t - LagPar_Amf(1);     % Female lag - There is no lag

            Del = [tau_e, tau_N1, tau_N2, tau_N3, tau_N4, tau_N5, ...
                   tau_Am, tau_Anmf, tau_Amf];
             
        end


    % Fertility rate function

        function B = FertRate(T, Parameters)

            alpha = Parameters(1); 
            gamma = Parameters(2); 
            lambda = Parameters(3); 
            delta = Parameters(4); 
            tau = Parameters(5);
            
            B = alpha * ((gamma + 1)/(pi * lambda^(2 * gamma + 2)) * ...
                   (lambda^2 - ((T - tau)^2 + delta^2))^gamma);

        end


    % Development rate function

        function G = DevRate(T, Parameters)

            a = Parameters(1);
            T_L = Parameters(2);
            T_M = Parameters(3);
            m = Parameters(4);

            % This if/else statement is needed to ensure that the solution
            % is biologically reasonable
            
            if T < T_L || T > T_M
                G = 0;
            else
                G = a * T * (T - T_L) * (T_M - T)^(1/m);
            end

        end


    % Mortality rate function

        function M = MortRate(T, Parameters)

            a = Parameters(1); 
            b = Parameters(2);
            c = Parameters(3);
            d = Parameters(4);
            e = Parameters(5);

            M = a * T^4 + b * T^3 + c * T^2 + d * T + e;

            % This if/else statement is needed to ensure that the solution
            % is biologically reasonable
            
            if M < 0
                M = 0;
            else
                M = (a * T^4 + b * T^3 + c * T^2 + d * T + e);
            end
               
        end
       

    % DDE system 

        function dydt_partial = ddefun_partial(t, y, Z, SR, FertPar, ...
                                MortPar_Egg, MortPar_N1, MortPar_N2, ...
                                MortPar_N3, MortPar_N4, MortPar_N5, ...
                                DevRate_Egg, DevRate_N1, DevRate_N2, ...
                                DevRate_N3, DevRate_N4, DevRate_N5, ...
                                DevRate_Ad, TempArray)

            % Approximation of the lags - Needed by ddesd

            ylag1 = Z(1);    % Eggs lag
            ylag2 = Z(2);    % N1 lag
            ylag3 = Z(3);    % N2 lag
            ylag4 = Z(4);    % N3 lag
            ylag5 = Z(5);    % N4 lag
            ylag6 = Z(6);    % N5 lag
            ylag7 = Z(7);    % Adult males lag
            ylag8 = Z(8);    % Female mating lag - Preoviposition period!
            ylag9 = Z(9);    % Female lag

            % It needs to call the class containing the functions needed,
            % also if the present function is contained in the same class!

            F = Functions;

            % Calculate the daily temperature from the
            % 'TemperatureInput.xlsx' file in 'Parameters.m'

            time = int32(t);
            temp = F.TempFunction(time, TempArray);
            
            % ODE system
        
                % y(1) = eggs without lag
                % y(2) = N1 without lag
                % y(3) = N2 without lag
                % y(4) = N3 without lag
                % y(5) = N4 without lag
                % y(6) = N5 without lag                
                % y(7) = males without lag
                % y(8) = non mated females without lag
                % y(9) = mated females without lag
                % y(10) = mortality storage
            
            dydt_partial = [ F.DevRate(temp, DevRate_Ad) * ...             % Eggs
                               F.FertRate(temp, FertPar) * y(9) ...
                             - F.DevRate(temp, DevRate_Egg) * y(1) ...
                             - F.MortRate(temp, MortPar_Egg) * y(1);

                             F.DevRate(temp, DevRate_Egg) * ylag1 ...      % N1
                             - F.DevRate(temp, DevRate_N1) * y(2) ...
                             - F.MortRate(temp, MortPar_N1) * y(2);

                             F.DevRate(temp, DevRate_N1) * ylag2 ...       % N2
                             - F.DevRate(temp, DevRate_N2) * y(3) ...
                             - F.MortRate(temp, MortPar_N2) * y(3);

                             F.DevRate(temp, DevRate_N2) * ylag3 ...       % N3
                             - F.DevRate(temp, DevRate_N3) * y(4) ...
                             - F.MortRate(temp, MortPar_N3) * y(4);

                             F.DevRate(temp, DevRate_N3) * ylag4 ...       % N4
                             - F.DevRate(temp, DevRate_N4) * y(5) ...
                             - F.MortRate(temp, MortPar_N4) * y(5);

                             F.DevRate(temp, DevRate_N4) * ylag5 ...       % N5
                             - F.DevRate(temp, DevRate_N5) * y(6) ...
                             - F.MortRate(temp, MortPar_N5) * y(6);

                             (1 - SR) * F.DevRate(temp, DevRate_N5) * ...  % Am 
                             ylag6 - F.DevRate(temp, DevRate_Ad) * y(7);

                             SR * F.DevRate(temp, DevRate_N5) * ylag6 ...  % Anmf
                             - y(8);

                             ylag8 - F.DevRate(temp, DevRate_Ad) * ...     % Amf
                             ylag8 - F.DevRate(temp, DevRate_Ad) * y(9);

                             F.MortRate(temp, MortPar_Egg) * y(1) + ...    % Deads
                             F.MortRate(temp, MortPar_N1) * y(2) + ...
                             F.MortRate(temp, MortPar_N2) * y(3) + ...
                             F.MortRate(temp, MortPar_N3) * y(4) + ...
                             F.MortRate(temp, MortPar_N4) * y(5) + ...
                             F.MortRate(temp, MortPar_N5) * y(6) + ...
                             F.DevRate(temp, DevRate_Ad) * y(7) + ...
                             F.DevRate(temp, DevRate_Ad) * y(8) +...
                             F.DevRate(temp, DevRate_Ad) * y(9) ];

        end


    % Define the solution trace for the DDE

        function s = history(t, s)

            s = 2 * heaviside(t) * s;

        end


    % Associated ODE system - No lags, ODE

        function dydt_ODE = ODEfun_partial(t, y, SR, FertPar, ...
                               MortPar_Egg, MortPar_N1, MortPar_N2, ...
                               MortPar_N3, MortPar_N4, MortPar_N5, ...
                               DevRate_Egg, DevRate_N1, DevRate_N2, ...
                               DevRate_N3, DevRate_N4, DevRate_N5, ...
                               DevRate_Ad, TempArray)

            % It needs to call the class containing the functions needed,
            % also if the present function is contained in the same class!

            F = Functions;

            % Calculate the daily temperature from the
            % 'TemperatureInput.xlsx' file in 'Parameters.m'

            time = int32(t);
            temp = F.TempFunction(time, TempArray);
            
            % ODE system
        
                % y(1) = eggs without lag
                % y(2) = N1 without lag
                % y(3) = N2 without lag
                % y(4) = N3 without lag
                % y(5) = N4 without lag
                % y(6) = N5 without lag                
                % y(7) = males without lag
                % y(8) = non mated females without lag
                % y(9) = mated females without lag
                % y(10) = mortality storage
            
            E = F.DevRate(temp, DevRate_Ad) * F.FertRate(temp, FertPar) * y(9) ...
                    - F.DevRate(temp, DevRate_Egg) * y(1) ...
                    - F.MortRate(temp, MortPar_Egg) * y(1);

            N1 = F.DevRate(temp, DevRate_Egg) * y(1) ...
                    - F.DevRate(temp, DevRate_N1) * y(2) ...
                    - F.MortRate(temp, MortPar_N1) * y(2);

            N2 = F.DevRate(temp, DevRate_N1) * y(2) ...
                    - F.DevRate(temp, DevRate_N2) * y(3) ...
                    - F.MortRate(temp, MortPar_N2) * y(3);

            N3 = F.DevRate(temp, DevRate_N2) * y(3) ...
                    - F.DevRate(temp, DevRate_N3) * y(4) ...
                    - F.MortRate(temp, MortPar_N3) * y(4);

            N4 = F.DevRate(temp, DevRate_N3) * y(4) ...
                    - F.DevRate(temp, DevRate_N4) * y(5) ...
                    - F.MortRate(temp, MortPar_N4) * y(5);

            N5 = F.DevRate(temp, DevRate_N4) * y(5) ...
                    - F.DevRate(temp, DevRate_N5) * y(6) ...
                    - F.MortRate(temp, MortPar_N5) * y(6);

            Am = (1 - SR) * F.DevRate(temp, DevRate_N5) * y(6) ...
                    - F.DevRate(temp, DevRate_Ad) * y(7);

            Anmf = SR * F.DevRate(temp, DevRate_N5) * y(6) - y(8);

            Amf = y(8) - F.DevRate(temp, DevRate_Ad) * y(8) ...
                    - F.DevRate(temp, DevRate_Ad) * y(9);

            Deads = F.MortRate(temp, MortPar_Egg) * y(1) + ...
                    F.MortRate(temp, MortPar_N1) * y(2) + ...
                    F.MortRate(temp, MortPar_N2) * y(3) + ...
                    F.MortRate(temp, MortPar_N3) * y(4) + ...
                    F.MortRate(temp, MortPar_N4) * y(5) + ...
                    F.MortRate(temp, MortPar_N5) * y(6) + ...
                    F.DevRate(temp, DevRate_Ad) * y(7) + ...
                    F.DevRate(temp, DevRate_Ad) * y(8) +...
                    F.DevRate(temp, DevRate_Ad) * y(9);

            % Final storage for the ode45 algorithm

            dydt_ODE = [E; N1; N2; N3; N4; N5; Am; Anmf; Amf; Deads];

        end

    end

end
