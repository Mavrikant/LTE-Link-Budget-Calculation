clc;
clear variables;
close all;

Fc = 1800; % Carrier freq (Mhz) (for LTE in Turkey: 800, 900, 1800, 2100, 2600(only indoor femtocell) 
Cell_size = 2000; % Micro cell (m)
H_bts = 40; % Height of BTS
H_ue = 3 ; % Height of user equipment
UE_number = 1000; % User equipment (phone, tablet ...) number
Threshold= -80 ; % UE connection threshold (Db)
Tx_power = 46; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi) 
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss= 3; % Body loss at reviever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss;% Effective isotropic radiated power (dBm)

UE_database=zeros(UE_number,4); % Matrix for user positions other user related informations

UE_database(:,1) = randi([-Cell_size,Cell_size], 1, UE_number); %generate random user position X (meter)
UE_database(:,2) = randi([-Cell_size,Cell_size], 1, UE_number); %generate random user position Y (meter)
UE_database(:,3) = sqrt(UE_database(:,1).*UE_database(:,1) + UE_database(:,2).*UE_database(:,2)); % Calculated distane between user and BTS (meter)

% Cost-231 Model (also known as COST-Hata-Model) 
% http://mobilityfirst.winlab.rutgers.edu/~narayan/Course/Wless/Lecture_3_RadioPropagationModel_Sneha.pdf
% Fc limit 1500-2000
ahm = 3.2*(log10(1.75*H_ue))^2 - 4.97; % for large cities
A = 46.3 + 33.9*log10(Fc) - 13.82*log10(H_bts) - ahm; 
B = 44.9 - 6.55*log10(H_bts);
C = 3; % 0 for medium-size city and suburban; 3 for metropolitan centers
Pathloss_formula = A + B*log10(UE_database(:,3)/1000) + C;  %(dB) (distance in Km)

Shadowing_eff = normrnd (0,12,[UE_number,1]); % http://morse.colorado.edu/~tlen5510/text/classwebch4.html - https://www.quora.com/Wireless-Communication-How-do-we-simulate-Shadow-Fading-using-Matlab-lognrnd-0-%CF%83-or-normrnd-0-%CF%83
UE_database(:,4) = Tx_EiRP - Pathloss_formula - Shadowing_eff - Rx_body_loss ;% Recieved power by user 

figure (1);
    Distance = linspace(0,Cell_size,1000); % 0-2Km, 1K sample
    plot(Distance, A + B*log10(Distance/1000) + C) % Distance in Km
    grid on;
    title(['Cost-231 Model, Fc=' num2str(Fc) ', H-bts=' num2str(H_bts)])
    xlabel('Distance in meter')
    ylabel('Pathloss in Db')


Connected_users = find(UE_database(:,4) > Threshold); % Find connected UE_id numbers

figure (2);
    plot(0, 0, 'Ob', 'LineWidth', 3);%BTS at center
    title(['Cost-231 Model, Fc=' num2str(Fc) ', H-bts=' num2str(H_bts) ', threshold=' num2str(Threshold)])
    hold on;
    grid on;
    for i=1:UE_number
        if (~isempty(find(Connected_users==i, 1))) == 0
            plot(UE_database(i,1), UE_database(i,2), '.r'); % Not Connected
            hold on;
        else
            plot(UE_database(i,1), UE_database(i,2), 'og'); % Connected
            hold on;
        end 
    end

    figure (3);
        ecdf(UE_database(:,4))
        title('CDF')
        grid on;
        
    figure (4);
        histogram(UE_database(:,4))
        title('Histogram of rec')
        grid on;
    