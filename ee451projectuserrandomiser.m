clc;
clear all;
close all;

% Code Style Guide
% 1 - User _ in variable names
% 2 - Use space before and after +,-,=
% 3 - Use space after ,
%
%


Fc = 2000; % Carrier freq (Mhz)
hb = 40;
User_number = 1000;

Tx_power = 46; % BTS power (dBm) 
Tx_a_gain = 18; % Anten gain (dBi)
Tx_c_loss = 2.5; % Anten  cable loss (dB)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss;% Effective isotropic radiated power (dBm)

A= 69.55 + 26.16*log10(Fc) - 13.82*log10(hb);
B= 44.9 - 6.55*log10(hb);
D= 4.78*log10(Fc)^2 + 18.33*log10(Fc) + 40.94;

User_database=zeros(User_number,4); % Matrix for user positions other user related informations

User_database(:,1) = randi([-15000,15000], 1, User_number); %generate random user position X (meter)
User_database(:,2) = randi([-15000,15000], 1, User_number); %generate random user position Y (meter)
User_database(:,3) = sqrt(User_database(:,1).*User_database(:,1) + User_database(:,2).*User_database(:,2)); % Calculated distane between user and BTS (meter)

Pathloss_formula = A + B*log10(User_database(:,3)) - D; % Pathloss for suburban area
User_database(:,4) = Tx_EiRP - Pathloss_formula; % Recieved power by user

scatter(User_database(:,1),User_database(:,2)); %%plot user positions