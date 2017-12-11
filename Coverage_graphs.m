clc;
clear variables;
close all;

Cell_size = 30000;
Sample_size= 1000;
Distance = linspace(0,Cell_size,Sample_size);
Coverage1 = zeros(1, Sample_size);
Coverage2 = zeros(1, Sample_size);
Coverage3 = zeros(1, Sample_size);



%% Effect of frequency on coverage
Tx_power = 43; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)
parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, sqrt(8), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Path_loss_func(900,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
end
figure (1);
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Effect of frequency on coverage';['URBAN, HATA Model, H-bts=30m, Tx-power=43dB, Threshold=' num2str(Rec_sens(1,1)) 'dB, 4QAM-voice']});
    xlabel('Distance (m)');
    ylabel('Probability');
    legend('900Mhz','1800Mhz')
    
%% Effect of power on coverage
Tx_power = 43; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)
parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, sqrt(8), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP -3 - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP +3 - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
end
figure (2);
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Effect of bts power on coverage';['URBAN, COST Model, Fc=1800Mhz, H-bts=30m, Threshold=' num2str(Rec_sens(1,1)) 'dB, 4QAM-voice']});
    xlabel('Distance (m)');
    ylabel('Probability');    
    legend('40dB','46dB')
    
%% Effect of bts height on coverage
Tx_power = 43; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)
parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, sqrt(8), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Path_loss_func(1800,3,20,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,3,40,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
end
figure (3);
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Effect of bts height on coverage';['URBAN, COST Model, Fc=1800Mhz, Tx-power=43dB, Threshold=' num2str(Rec_sens(1,1)) 'dB, 4QAM-voice']});
    xlabel('Distance (m)');
    ylabel('Probability');    
    legend('20m','40m')

%% Effect of UE height on coverage
Tx_power = 43; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)
parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, sqrt(8), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,10,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
end
figure (4);
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Effect of UE height on coverage';['URBAN, COST Model, Fc=1800Mhz, Tx-power=43dB, Threshold=' num2str(Rec_sens(1,1)) 'dB, 4QAM-voice']});
    xlabel('Distance (m)');
    ylabel('Probability');    
    legend('3m','10m')
    
%% Effect of modulation and datarate on coverage
figure (5);
Tx_power = 43; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi)
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)
parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, sqrt(8), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,1)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(2,1)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage3(i) = length(find(Power > Rec_sens(3,1)))/Sample_size; % Find connected UE number
end
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage3)) % Moving average smoothing
parfor i=1:Sample_size
    Shadowing_eff = normrnd (0, sqrt(8), [Sample_size, 1] ); % (Sample_size, 1) matrix
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage1(i) = length(find(Power > Rec_sens(1,2)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage2(i) = length(find(Power > Rec_sens(2,2)))/Sample_size; % Find connected UE number
    Power = Tx_EiRP - Path_loss_func(1800,3,30,Distance(i),1) - Shadowing_eff - Rx_body_loss; % Received power by UE 
    Coverage3(i) = length(find(Power > Rec_sens(3,2)))/Sample_size; % Find connected UE number
end
    plot (Distance, smooth(Coverage1)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage2)) % Moving average smoothing
    hold on;
    plot (Distance, smooth(Coverage3)) % Moving average smoothing
    axis([-inf +inf 0 1]) % fix y axis between 0 and 1
    grid on;
    title({'Effect of bts height on coverage';['URBAN, COST Model, Fc=1800Mhz, Tx-power=43dB, H-bts=30m, ']});
    xlabel('Distance (m)');
    ylabel('Probability');    
    legend('4QAM voice','16QAM voice','64QAM voice','4QAM data','16QAM data','64QAM data')
    
    
    
    
