clc;
clear variables;
close all;

Cell_size = 15000;
Sample_size= 5000;
Distance = linspace(0,Cell_size,Sample_size);





Tx_power = 46; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)
Coverage1 = zeros(1, Sample_size);
Coverage2 = zeros(1, Sample_size);

parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, 8, [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Path_loss_func(900,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,2)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(900,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(3,2)))/Sample_size; % Find connected UE number
end
figure (5);
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    %title({'Coverage probability vs Distance';['URBAN, Cost-231 Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, Threshold-voice=' num2str(Threshold_voice) 'dB']});
    xlabel('Distance (m)');
    ylabel('Probability');
    
    
    
    
    