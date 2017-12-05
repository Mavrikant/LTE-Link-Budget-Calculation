% noise floor calc https://www.iis.fraunhofer.de/content/dam/iis/en/doc/pr/2012/Full_HD_Voice_engl.pdf
clc;
clear variables;
close all;


Temp=293;
KBoltzman=1.38*(10^(-23));
BW=10000000;%10MHz
Rd=8000000; %datarate for QPSK with 20MHz BW without MIMO taken from http://anisimoff.org/eng/lte_throughput_calculator.html
Rv=7000;%datarate for voice
EbN0vqpsk= 10.5; %dB taken from graph at https://www.gaussianwaves.com/2010/04/performance-comparison-of-digital-modulation-techniques-2/
EbN0dqpsk=7;%dB for QPSK taken from graph at https://www.gaussianwaves.com/2010/04/performance-comparison-of-digital-modulation-techniques-2/
EbN0v64qam= 13;
EbN0d64qam= 19;
NoisefloordB=10*log10(KBoltzman*Temp*BW);%will result in dBwatt for dBMwatt add 30
NoisefloordBm=NoisefloordB+30;
NF=7;% taken from https://sites.google.com/site/lteencyclopedia/lte-radio-link-budgeting-and-rf-planning
SNRvqpsk=EbN0vqpsk + 10*log10(Rv/BW);
SNRdqpsk=EbN0dqpsk + 10*log10(Rd/BW);
SNRv64qam=EbN0v64qam + 10*log10(Rv/BW);
SNRd64qam=EbN0d64qam + 10*log10(Rd/BW);

Recsensdqpsk=SNRdqpsk+NoisefloordBm+NF;
Recsensvqpsk=SNRvqpsk+NoisefloordBm+NF;
Recsensd64qam=SNRd64qam+NoisefloordBm+NF;
Recsensv64qam=SNRv64qam+NoisefloordBm+NF;
