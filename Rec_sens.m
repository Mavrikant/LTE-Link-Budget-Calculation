% Modulation 
% 1 = 4QAM
% 2 = 16QAM
% 3 = 64AQM
% App_type
% 1 = Voice
% 2 = Data

function Sens = Rec_sens(Modulation,App_type)

    Temp=293;
    k=1.38*10^-23;
    BW=[3*10^6 10*10^6]; %We assume 50 resource blocks, equal 9 MHz, transmission for 1 Mbps downlink for data. https://sites.google.com/site/lteencyclopedia/lte-radio-link-budgeting-and-rf-planning
    DR=[7*10^3 1*10^6]; %Data rate for data and voice application
    EbN0=[7 11; 11 15; 15 19]; %SNR for 4QAM 16QAM 64 QAM / 10^-3 10^-6  AWGN channel
    Noise_figure=9;% taken from https://sites.google.com/site/lteencyclopedia/lte-radio-link-budgeting-and-rf-planning

    Sens = 10*log10(k*Temp*BW(App_type)) + 30 + Noise_figure + EbN0(Modulation, App_type) + 10*log10(DR(App_type)./BW(App_type)); % [dBmilliwatts]

end