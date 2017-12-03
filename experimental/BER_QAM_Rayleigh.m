%http://www.raymaps.com/index.php/theoretical-ber-of-m-qam-in-rayleigh-fading/
clc;
clear variables;
close all;

EbNo = linspace(0,60,200);
four_QAM = 1/2 * ( 1 - sqrt(10.^(EbNo/10)./(1+10.^(EbNo/10))) );
sixteen_QAM = 3/8 * ( 1 - sqrt(2/5*10.^(EbNo/10)./(1+2/5*10.^(EbNo/10))) );
sixty_four_QAM = 7/24 * ( 1 - sqrt(1/7*10.^(EbNo/10)./(1+1/7*10.^(EbNo/10))) );

figure (1)
    semilogy(EbNo,four_QAM)
    hold on;
    semilogy(EbNo,sixteen_QAM)
    hold on;
    semilogy(EbNo,sixty_four_QAM)
    hold on;
    axis([-inf +inf 10^-6 1])
    legend('4QAM','16QAM','64QAM')
    grid on;
    title('Theoretical BER of M-QAM in Rayleigh Fading')
    xlabel('Eb/No (dB)')
    ylabel('BER')
