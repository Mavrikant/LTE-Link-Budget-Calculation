clc;
clear variables;
close all;

Cell_size = 15000;
Sample_size= 1000;
Distance = linspace(0,Cell_size,Sample_size);

%% Effect of frequency on pathloss
figure (1);
    Pathloss = Path_loss_func(900,3,30,Distance,0);
    plot(Distance, Pathloss);
    hold on;
    Pathloss = Path_loss_func(1400,3,30,Distance,0);
    plot(Distance, Pathloss);
    title({'Effect of frequency on pathloss';'HATA Model, Rural, H-ue=3m, H-bts=30m,'});
    xlabel('Distance [meter]');
    ylabel('Pathloss [dB]');
    legend('900Mhz','1400Mhz')
    axis([-inf +inf 0 180]); 
    grid on;
    
%% Effect of UE height on pathloss
figure (2);
    Pathloss = Path_loss_func(900,3,30,Distance,0);
    plot(Distance, Pathloss);
    hold on;
    Pathloss = Path_loss_func(900,10,30,Distance,0);
    plot(Distance, Pathloss);
    title({'Effect of UE height on pathloss';'HATA Model, Rural, Fc=900Mhz, H-bts=30m,'});
    xlabel('Distance [meter]');
    ylabel('Pathloss [dB]');
    legend('3m','10m')
    axis([-inf +inf 0 180]); 
    grid on;
    
%% Effect of BTS height on pathloss
figure (3);
    Pathloss = Path_loss_func(900,3,20,Distance,0);
    plot(Distance, Pathloss);
    hold on;
    Pathloss = Path_loss_func(900,3,40,Distance,0);
    plot(Distance, Pathloss);
    title({'Effect of BTS height on pathloss';'HATA Model, Rural, Fc=900Mhz, H-ue=3m,'});
    xlabel('Distance [meter]');
    ylabel('Pathloss [dB]');
    legend('20m','40m')
    axis([-inf +inf 0 180]); 
    grid on;
    
%% Effect of area type on pathloss
figure (4);
    Pathloss = Path_loss_func(900,3,30,Distance,0);
    plot(Distance, Pathloss);
    hold on;
    Pathloss = Path_loss_func(900,3,30,Distance,1);
    plot(Distance, Pathloss);
    title({'Effect of BTS height on pathloss';'HATA Model, Fc=900Mhz, H-ue=3m, h-bts=30m'});
    xlabel('Distance [meter]');
    ylabel('Pathloss [dB]');
    legend('Rural','Urban')
    axis([-inf +inf 0 180]); 
    grid on;
