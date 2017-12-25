clc;
clear variables;
close all;


x0=0;
y0=0;
Cell_size = 20000; % Macro cell (m)
rangeblocks=500:500:Cell_size;

temp=zeros(length(rangeblocks),1);
a=1;
while (a<=1)
RE_number = 100/(71.4*10^-6)*12*0.85;
Fc = 900; % Carrier freq (Mhz) (for LTE in Turkey: 800, 900, 1800, 2100, 2600(only indoor femtocell) 


H_bts = 30; % Height of BTS; http://ftp.tiaonline.org/TR-8/TR-8.18.4/Working/WG4-8.18.4_16-05-039-R6%20LTE%20Transmitter%20Characteristics.pdf
H_ue = 3; % Height of user equipment
UE_density =2; %Active user density (/km2)
UE_number = floor(UE_density*(pi*(Cell_size/1000)^2)); % User equipment (phone, tablet ...) number
Threshold_voice= Rec_sens(1,1) ; % UE connection Threshold_voice (dB)
Threshold_data= Rec_sens(1,2) ; % UE connection Threshold_data (dB)
Data_UE_rate = 0.5; % Ratio of data requests by UE
Data_request= 8*1024*1024; %1Mbps
Voice_request= 7*1024 ; %7Kbps
Tx_power = 46; % BTS power (dBm)  
Tx_a_gain = 18; % Antenna gain (dBi) 
Tx_c_loss = 2.5; % Antenna  cable loss (dB)
Rx_body_loss = 3; % Body loss at reciever side (dB) (User Body Loss Study for Popular Smartphones - http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7228963)
Tx_EiRP = Tx_power + Tx_a_gain - Tx_c_loss; % Effective isotropic radiated power (dBm)

%% Create UE positions and their distances
UE_database=zeros(UE_number,8); % Matrix for UE positions other UE related informations
angle1 = 0;
angle2 = 2*pi;
t=(angle2 - angle1) * rand(UE_number,1) + angle1;
r = Cell_size*sqrt(rand(UE_number,1));
UE_database(:,1) = x0 + r.*cos(t);
UE_database(:,2) = y0 + r.*sin(t);
UE_database(:,3) = sqrt(UE_database(:,1).^2 + UE_database(:,2).^2); % Calculated distance between UE and BTS (meter)
%%UE_database(:,4) recieved power
UE_database(:,5) = rand(UE_number,1) < Data_UE_rate; % User type (1=Data, 0=Voice)
%%UE_database(:,6) used MCS
%%UE_database(:,7) needed Resource element


%% Calculate received power by UE matrix
%Okumura-Hata Model model for open area (Developed by Masaharu Hata after Okumura) (parameters for rural area)
Pathloss_formula = Path_loss_func(Fc,H_ue,H_bts,UE_database(:,3),0); %(dB) (distance in Km)
Shadowing_eff = normrnd(0,sqrt(8),[UE_number,1]); % http://morse.colorado.edu/~tlen5510/text/classwebch4.html - https://www.quora.com/Wireless-Communication-How-do-we-simulate-Shadow-Fading-using-Matlab-lognrnd-0-%CF%83-or-normrnd-0-%CF%83
UE_database(:,4) = Tx_EiRP - Pathloss_formula - Shadowing_eff - Rx_body_loss ;% Received power by UE 


%% Choose best MCS for users
MCS_database = MCS_info(); %MCS_number - Modulation - Code_Rate -  Requered_power(10^-3) - Requered_power(10^-6) 
for i=1:UE_number
        if UE_database(i,5) %Data
            UE_database(i,6) = sum(UE_database(i,4) > MCS_database(:,5));
        else %Voice
            UE_database(i,6) = sum(UE_database(i,4) > MCS_database(:,4));
        end
end

%% Sort for recieved power
UE_database = sortrows(UE_database,-4); %sort it acording to recieved power. Give priority to best users.
Coverage=zeros(length(rangeblocks),3);
figure (8);
    plot(0, 0, '*k', 'LineWidth', 3); % BTS at centers
    title(['RURAL, HATA Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB,'])
    hold on;
    grid on;
    for i=1:UE_number
        if UE_database(i,5) %Data
            if UE_database(i,6)>0
                Needed_RE = ceil(Data_request/MCS_database(UE_database(i,6),3)/MCS_database(UE_database(i,6),2));
                UE_database(i,7) = Needed_RE;
                if RE_number > Needed_RE %Connected
                    UE_database(i,8)= 1;
                    plot(UE_database(i,1), UE_database(i,2), '*g'); 
                    RE_number = RE_number - Needed_RE;
                else % NOT connected
                    UE_database(i,8)= 0;
                    plot(UE_database(i,1), UE_database(i,2), '*r'); 
                end
            else
                UE_database(i,8)= 0;
                plot(UE_database(i,1), UE_database(i,2), '*r'); 
            end
        else %Voice
            if UE_database(i,6)>0
                Needed_RE = ceil(Voice_request/MCS_database(UE_database(i,6),3)/MCS_database(UE_database(i,6),2));
                UE_database(i,7) = Needed_RE;
                if RE_number > Needed_RE %Connected
                    UE_database(i,8)= 1;
                    plot(UE_database(i,1), UE_database(i,2), '.g'); 
                    RE_number = RE_number - Needed_RE;
                else % NOT connected
                    UE_database(i,8)= 0;
                    plot(UE_database(i,1), UE_database(i,2), '.r'); 
                end
            else
                UE_database(i,8)= 0;
                plot(UE_database(i,1), UE_database(i,2), '.r');
            end
        end 
    end
for i=1:UE_number
    for j=1:length(rangeblocks)
        if(UE_database(i,3)<j*500 && UE_database(i,3)>(j-1)*500)
             Coverage(j,1)=Coverage(j,1)+1;
             if(UE_database(i,8)==1)
                 Coverage(j,2)=Coverage(j,2)+1;
             end
         end
     end
end

Coverage(:,3)=100*Coverage(:,2)./Coverage(:,1);
temp(:,a)=Coverage(:,3);
a=a+1;
a
end
avgmat=mean(temp,2);
figure (5);
plot(rangeblocks,avgmat);
title(['RURAL, HATA Model, Fc=' num2str(Fc) 'Mhz, H-bts=' num2str(H_bts) 'm, Tx-power=' num2str(Tx_power) 'dB, User density=' num2str(UE_density) 'user per km^2,Data User Datarate=' num2str(Data_request) 'bps,Voice User Datarate=' num2str(Voice_request) 'bps,Data user to Voice user ratio=' num2str(Data_UE_rate) ])
    
