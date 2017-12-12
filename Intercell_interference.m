clc;
clear variables;
close all;

Fc = 1800; % Carrier freq (Mhz) (for LTE in Turkey: 800, 900, 1800, 2100, 2600(only indoor femtocell) 
Cell_size = 8000; % Micro cell (m)
Intercell_distance=4000;
H_bts = 30; % Height of BTS; http://ftp.tiaonline.org/TR-8/TR-8.18.4/Working/WG4-8.18.4_16-05-039-R6%20LTE%20Transmitter%20Characteristics.pdf
H_ue = 3; % Height of user equipment
UE_density = 5; %Active user density (/km2)
UE_number = floor(UE_density*(2*4*Cell_size^2/10^6)); % User equipment (phone, tablet ...) number
Threshold_voice= Rec_sens(1,1) ; % UE connection Threshold_voice (dB)
Threshold_data= Rec_sens(1,2) ; % UE connection Threshold_data (dB)
Tx_power = 43; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi) 
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)

%% Create UE positions and their distances
UE_database=zeros(UE_number,7); % Matrix for UE positions other UE related informations
UE_database(:,1) = randi([-2*Cell_size,2*Cell_size], 1, UE_number); % Create random UE position X (meter)
UE_database(:,2) = randi([-Cell_size,Cell_size], 1, UE_number); % Create random UE position Y (meter)
UE_database(:,3) = sqrt((UE_database(:,1)+Intercell_distance/2).^2 + UE_database(:,2).^2); % Distance to bts1
UE_database(:,4) = sqrt((UE_database(:,1)-Intercell_distance/2).^2 + UE_database(:,2).^2); % Distance to bts2
UE_database(:,5) = Tx_EiRP +3 - Path_loss_func(900,3,30,UE_database(:,3),1) - normrnd (0, sqrt(8), [UE_number, 1] );
UE_database(:,6) = Tx_EiRP -3 - Path_loss_func(900,3,30,UE_database(:,4),1) - normrnd (0, sqrt(8), [UE_number, 1] );

%% Draw UE positions and their status on map
figure (1);
    plot(-Intercell_distance/2, 0, 'ob', 'LineWidth', 3);%BTS1 at center
    hold on;
    plot(+Intercell_distance/2, 0, 'or', 'LineWidth', 3);%BTS2 at center
    title(['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-voice=' num2str(Threshold_voice) 'dB'])
    hold on;
    grid on;
    for i=1:UE_number
        if UE_database(i,5) > UE_database(i,6)
            plot(UE_database(i,1), UE_database(i,2), '*b');
        else
            plot(UE_database(i,1), UE_database(i,2), '*r');
        end
    end

    

    %%
    Intercell_distance=8000;
    Sample_size=100;
    X=linspace(-2*Cell_size,+2*Cell_size,Sample_size*2);
    Y=linspace(-Cell_size,+Cell_size,Sample_size);
    Z=zeros(Sample_size,Sample_size*2);
    for y=1:length(Y)
        parfor x=1:length(X)
            bts1 = Tx_EiRP +3 - Path_loss_func(900,3,30,sqrt((X(x)+Intercell_distance/2).^2 + Y(y).^2),1) - normrnd (0, sqrt(8));
            bts2 = Tx_EiRP -3 - Path_loss_func(900,3,30,sqrt((X(x)-Intercell_distance/2).^2 + Y(y).^2),1) - normrnd (0, sqrt(8));
            Z(y,x) = max(bts1,bts2) - min(bts1,bts2); 
        end
    end
    figure(99)
    title('Signal to interference ratio. RSSI based cell selection.')
    mesh(Z)
    
    figure (98)
    pcolor(Z)