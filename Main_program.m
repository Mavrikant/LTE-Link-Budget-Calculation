clc;
clear all;
close all;

% Code Style Guide
% 1 - User _ in variable names
% 2 - All variables start with capital letter
% 3 - Use space before and after +, -, =, >, <
% 4 - Use space after ,
%
%


Fc = 1800; % Carrier freq (Mhz) (for LTE in Turkey: 800, 900, 1800, 2100, 2600(only indoor femtocell) 
H_bts = 40; % Height of BTS
UE_number = 1000; % User equipment (phone, tablet ...) number
Threshold= -210 ; % UE connection threshold (Db)
Tx_power = 46; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss;% Effective isotropic radiated power (dBm)

UE_database=zeros(UE_number,4); % Matrix for user positions other user related informations

UE_database(:,1) = randi([-15000,15000], 1, UE_number); %generate random user position X (meter)
UE_database(:,2) = randi([-15000,15000], 1, UE_number); %generate random user position Y (meter)
UE_database(:,3) = sqrt(UE_database(:,1).*UE_database(:,1) + UE_database(:,2).*UE_database(:,2)); % Calculated distane between user and BTS (meter)

%%%%%%%%
% Okumura-Hata Model model for open area (Developed by Masaharu Hata after Okumura)
% A = 69.55 + 26.16*log10(Fc) - 13.82*log10(hb);
% B = 44.9 - 6.55*log10(hb);
% D = 4.78*log10(Fc)^2 + 18.33*log10(Fc) + 40.94;
% Pathloss_formula = A + B*log10(UE_database(:,3)) - D; 

%%%%%%%%%%%%%%%
% Cost-231 Model (also known as COST-Hata-Model) 
% http://mobilityfirst.winlab.rutgers.edu/~narayan/Course/Wless/Lecture_3_RadioPropagationModel_Sneha.pdf
A = 46.3 + 33.9*log10(Fc) - 13.82*log10(H_bts); % a(hm) need to be clarified
B = 44.9 - 6.55*log10(H_bts);
C = 0; % 0 for medium-size city and suburban; 3 for metropolitan centers
Pathloss_formula = A + B*log10(UE_database(:,3)) + C;  %(dB)
Shadowing_eff = lognrnd(0,3,[UE_number,1]); % http://morse.colorado.edu/~tlen5510/text/classwebch4.html
UE_database(:,4) = Tx_EiRP - Pathloss_formula - Shadowing_eff ;% Recieved power by user 

figure (1);
    Distance = linspace(0,20000,1000); % 0 -20Km, 1K sample
    plot(Distance, A + B*log10(Distance) + C)
    title(['Cost-231 Model, Fc=' num2str(Fc) ', H-bts=' num2str(H_bts)])
    xlabel('Distance in meter')
    ylabel('Pathloss in Db')


Connected_users = find(UE_database(:,4) > Threshold); % Find connected UE_id numbers

figure (2);
    plot(0, 0, 'Ob', 'LineWidth', 3);%BTS at center
    title(['Cost-231 Model, Fc=' num2str(Fc) ', H-bts=' num2str(H_bts) ', threshold=' num2str(Threshold)])
    hold on;
    for i=1:UE_number
        if (~isempty(find(Connected_users==i, 1))) == 0
            plot(UE_database(i,1), UE_database(i,2), '.r'); % Connected
            hold on;
        else
            plot(UE_database(i,1), UE_database(i,2), 'og'); % NOT connected
            hold on;
        end 
    end
