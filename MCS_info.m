%Returns MCS_number - Modulation - Code_Rate -  Requered_power(10^-3) - Requered_power(10^-6) 

function X = MCS_info()
    MCS_number = 0:1:27; %% total 28 MCS
    SNR_3 = [-3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24] + 10; %% Interpolated from https://www.researchgate.net/figure/LTE-DL-AWGN-Reference-BLER-rv-0-for-SISO-configuration-and-bandwidth-of-1-PRB_234101185
    SNR_6 = SNR_3 + 5; % Assume there is always 5 dB difference. 
    Code_Rate= [0.12 0.16 0.19 0.25 0.3 0.37 0.44 0.52 0.59 0.67 0.33 0.37 0.43 0.48 0.54 0.6 0.64 0.43 0.46 0.51 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.89];
    M = [4 4 4 4 4 4 4 4 4 4 6 6 6 6 6 6 6 8 8 8 8 8 8 8 8 8 8 8 ];
    
    Temp = 293;
    k = 1.38*10^-23;
    BW = 15*10^3          ; %BW of one subcarrier
    SR = 1/(71.4*10^-6)   ; %Semybol rate
    Noise_figure = 9      ;% taken from https://sites.google.com/site/lteencyclopedia/lte-radio-link-budgeting-and-rf-planning

    voice = 10*log10(k*Temp*BW) + 30 + Noise_figure + SNR_3 + 10*log10(SR/BW); % [dBmilliwatts]
    data = 10*log10(k*Temp*BW) + 30 + Noise_figure + SNR_6 + 10*log10(SR/BW);   % [dBmilliwatts]
    
    %MCS_number - Modulation - Code_Rate -  Requered_power(10^-3) - Requered_power(10^-6) 
    X= transpose([MCS_number ; M ; Code_Rate ; voice ; data]) ;
end