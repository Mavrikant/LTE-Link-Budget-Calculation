% noise floor calc https://www.iis.fraunhofer.de/content/dam/iis/en/doc/pr/2012/Full_HD_Voice_engl.pdf

Temp=293;
KBoltzman=1.38*(10^(-23));
BW=20000000;%20MHz
R=15840000; %datarate for QPSK with 20MHz BW without MIMO taken from http://anisimoff.org/eng/lte_throughput_calculator.html
EbN0v= 10.5; %dB taken from graph at https://www.gaussianwaves.com/2010/04/performance-comparison-of-digital-modulation-techniques-2/
EbN0d=7;%dB for QPSK taken from graph at https://www.gaussianwaves.com/2010/04/performance-comparison-of-digital-modulation-techniques-2/
NoisefloordB=10*log10(KBoltzman*Temp*BW);%will result in dBwatt for dBMwatt add 30
NoisefloordBm=NoisefloordB+30;
NF=7;% taken from https://sites.google.com/site/lteencyclopedia/lte-radio-link-budgeting-and-rf-planning
SNR=EbN0v + 10*log10(R/BW);
Recsens=SNR+NoisefloordBm+NF;