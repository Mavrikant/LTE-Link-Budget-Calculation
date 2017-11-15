clc;
clear all;
close all;

% Code Style Guide
% 1 - User _ in variable names
% 2 - Use space before and after +,-,=
% 3 - Use space after ,
%
%


Fc = 1800; % Carrier freq (Mhz)
H_bts = 40; % Height of BTS
User_number = 1000;

Tx_power = 46; % BTS power (dBm) 
Tx_a_gain = 18; % Anten gain (dBi)
Tx_c_loss = 2.5; % Anten  cable loss (dB)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss;% Effective isotropic radiated power (dBm)

User_database=zeros(User_number,4); % Matrix for user positions other user related informations

User_database(:,1) = randi([-15000,15000], 1, User_number); %generate random user position X (meter)
User_database(:,2) = randi([-15000,15000], 1, User_number); %generate random user position Y (meter)
User_database(:,3) = sqrt(User_database(:,1).*User_database(:,1) + User_database(:,2).*User_database(:,2)); % Calculated distane between user and BTS (meter)

%%%%%%%%
% Okumura-Hata Model model for open area (Developed by Masaharu Hata after Okumura)
% A = 69.55 + 26.16*log10(Fc) - 13.82*log10(hb);
% B = 44.9 - 6.55*log10(hb);
% D = 4.78*log10(Fc)^2 + 18.33*log10(Fc) + 40.94;
% Pathloss_formula = A + B*log10(User_database(:,3)) - D; 

%%%%%%%%%%%%%%%
% Cost-231 Model (also known as COST-Hata-Model) 
% http://mobilityfirst.winlab.rutgers.edu/~narayan/Course/Wless/Lecture_3_RadioPropagationModel_Sneha.pdf
A = 46.3 + 33.9*log10(Fc) - 13.82*log10(H_bts); % a(hm) need to be clarified
B = 44.9 - 6.55*log10(H_bts);
C = 0; % 0 for medium-seze city and suburban; 3 for metropolitancenters
Pathloss_formula = A + B*log10(User_database(:,3)) + C;  %(dB)

figure 1;
  distance=linspace(0,20000,1000); % 0 -20Km, 1K sample
  title(['Cost-231 Model, Fc=' num2str(Fc) ', H_bts=' num2str(H_bts)])
  plot(distance,A + B*log10(distance) + C)
  xlabel('Distance in meter')
  ylabel('Pathloss in Db')

User_database(:,4) = Tx_EiRP - Pathloss_formula; % Recieved power by user

figure 2;
  scatter(User_database(:,1),User_database(:,2)); %%plot user positions