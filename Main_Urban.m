clc;
clear variables;
close all;

Fc = 1800; % Carrier freq (Mhz) (for LTE in Turkey: 800, 900, 1800, 2100, 2600(only indoor femtocell) 
Cell_size = 5000; % Micro cell (m)
H_bts = 30; % Height of BTS; http://ftp.tiaonline.org/TR-8/TR-8.18.4/Working/WG4-8.18.4_16-05-039-R6%20LTE%20Transmitter%20Characteristics.pdf
H_ue = 3; % Height of user equipment
UE_density = 50; %Active user density (/km2)
UE_number = floor(UE_density*(4*Cell_size^2/10^6)); % User equipment (phone, tablet ...) number
Threshold_voice= Rec_sens(1,1) ; % UE connection Threshold_voice (dB)
Threshold_data= Rec_sens(1,2) ; % UE connection Threshold_data (dB)
Data_UE_rate = 0.4; % Ratio of data requests by UE
Tx_power = 40; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi) 
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)

%% Create UE positions and their distances
UE_database=zeros(UE_number,5); % Matrix for UE positions other UE related informations
UE_database(:,1) = randi([-Cell_size,Cell_size], 1, UE_number); % Create random UE position X (meter)
UE_database(:,2) = randi([-Cell_size,Cell_size], 1, UE_number); % Create random UE position Y (meter)
UE_database(:,3) = sqrt(UE_database(:,1).^2 + UE_database(:,2).^2); % Calculated distance between UE and BTS (meter)
UE_database(:,5) = rand(UE_number,1) < Data_UE_rate; % User type (1=Data, 0=Voice)

%% Calculate received power by UE matrix
% Cost-231 Model (also known as COST-Hata Model) 
% http://mobilityfirst.winlab.rutgers.edu/~narayan/Course/Wless/Lecture_3_RadioPropagationModel_Sneha.pdf
% Fc limit 1500-2000
ahm = 3.2*(log10(1.75*H_ue))^2 - 4.97; % for large cities
A = 46.3 + 33.9*log10(Fc) - 13.82*log10(H_bts) - ahm; 
B = 44.9 - 6.55*log10(H_bts);
C = 3; % 0 for medium-size city and suburban; 3 for metropolitan centers
Pathloss_formula = A + B*log10(UE_database(:,3)/1000) + C; % (dB) (distance in Km)
Shadowing_eff = normrnd(0,sqrt(12),[UE_number,1]); % http://morse.colorado.edu/~tlen5510/text/classwebch4.html - https://www.quora.com/Wireless-Communication-How-do-we-simulate-Shadow-Fading-using-Matlab-lognrnd-0-%CF%83-or-normrnd-0-%CF%83
UE_database(:,4) = Tx_EiRP - Pathloss_formula - Shadowing_eff - Rx_body_loss; % Received   power by UE 

%% Draw UE positions and their status on map
figure (1);
    plot(0, 0, '*k', 'LineWidth', 3);%BTS at center
    title(['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-voice=' num2str(Threshold_voice) 'dB'])
    hold on;
    grid on;
    for i=1:UE_number
        if UE_database(i,5) %Data
            if UE_database(i,4) > Threshold_data %Connected
                plot(UE_database(i,1), UE_database(i,2), '*g'); 
            else % NOT connected
                plot(UE_database(i,1), UE_database(i,2), '*r'); 
            end
        else %Voice
            if UE_database(i,4) > Threshold_voice %Connected
                plot(UE_database(i,1), UE_database(i,2), '.g'); 
            else % NOT connected
                plot(UE_database(i,1), UE_database(i,2), '.r'); 
            end 
        end 
    end
    
%% Cumulative distribution of received power
    figure (3);
        ecdf(UE_database(:,4));
        title({'Cumulative distribution of received power';['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-voice=' num2str(Threshold_voice) 'dB']});
        xlabel('Received power (dB)');
        ylabel('Probability');
        grid on;
        
%% Histogram of received power by UE   
    figure (4);
        histogram(UE_database(:,4));
        title({'Histogram of received power by UE';['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-voice=' num2str(Threshold_voice) 'dB']});
        xlabel('Received power (dB)');
        ylabel('Count');
        grid on;
        
%% Coverage graph voice
Sample_size = 1000;       
Distance = linspace(0, Cell_size, Sample_size); % 0-2Km, 1K sample
Coverage = zeros(1, Sample_size);
for i=1:Sample_size
    Pathloss_formula = A + B*log10((Distance(i)./1000)*ones(Sample_size, 1)) + C; % Distance in Km; (Sample_size, 1) matrix
    Shadowing_eff = normrnd (0, sqrt(12), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Pathloss_formula - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage(i) = length(find(Power > Threshold_voice))/Sample_size; % Find connected UE number
end
clear Power Pathloss_formula Shadowing_eff Sample_size
figure (5);
    plot (Distance, smooth(Coverage)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Coverage probability vs Distance (voice)';['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-voice=' num2str(Threshold_voice) 'dB']});
    xlabel('Distance (m)');
    ylabel('Probability');
    
    
%% Coverage graph data
Sample_size = 1000;       
Distance = linspace(0, Cell_size, Sample_size); % 0-2Km, 1K sample
Coverage = zeros(1, Sample_size);
for i=1:Sample_size
    Pathloss_formula = A + B*log10((Distance(i)./1000)*ones(Sample_size, 1)) + C; % Distance in Km; (Sample_size, 1) matrix
    Shadowing_eff = normrnd (0, sqrt(12), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Pathloss_formula - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage(i) = length(find(Power > Threshold_data))/Sample_size; % Find connected UE number
end
clear Power Pathloss_formula Shadowing_eff Sample_size
figure (6);
    plot (Distance, smooth(Coverage)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Coverage probability vs Distance (data)';['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-data=' num2str(Threshold_sata) 'dB']});
    xlabel('Distance (m)');
    ylabel('Probability'); 
    
    
