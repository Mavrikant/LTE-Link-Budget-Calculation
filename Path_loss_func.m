% Type 0 = Rural
% Type 1 = Urban

function Pathloss = Path_loss_func(Fc,H_ue,H_bts,Distance,Type)

if Fc<1500 %HATA model
    A = 69.55 + 26.16*log10(Fc) - 13.82*log10(H_bts);
    B = 44.9 - 6.55*log10(H_bts);
    D = 4.78*log10(Fc)^2 - 18.33*log10(Fc) + 40.94;
    
    if Type %URBAN HATA
        ahm = 3.2*(log10(11.75*H_ue))^2 - 4.97; % large cities (fc >400MHz)
        Pathloss = A - ahm + B*log10(Distance/1000); %(dB) (distance in Km)
    else % RURAL HATA (open area)
        ahm = (1.1*log10(Fc) - 0.7)*H_ue - 1.56*log10(Fc) - 0.8; % for small or medium-sized city (See Wikipedia : Hata Model)
        Pathloss = A - ahm + B*log10(Distance/1000) - D;  %(dB) (distance in Km)     
    end
        
else
    A = 46.3 + 33.9*log10(Fc) - 13.82*log10(H_bts); 
    B = 44.9 - 6.55*log10(H_bts);
    
    if Type %URBAN COST-231
        C = 3;  %3 for metropolitan centers
        ahm = 3.2*(log10(11.75*H_ue))^2 - 4.97; % large cities (fc >400MHz)
        Pathloss = A - ahm + B*log10(Distance/1000) + C;  %(dB) (distance in Km)  
    else % RURAL COST-231
        C = 0; % 0 for medium-size city and suburban
        ahm = (1.1*log10(Fc) - 0.7)*H_ue - 1.56*log10(Fc) - 0.8; % for small or medium-sized city (See Wikipedia : Hata Model)
        Pathloss = A - ahm + B*log10(Distance/1000) + C;  %(dB) (distance in Km)  
    end
        
end