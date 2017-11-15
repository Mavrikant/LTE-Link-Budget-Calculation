clc
clear all
close all
fc=2000; %carrier freq in MHz 2000MHz=2GHz
hb=40;
Txpower=46;%dBm%
TxAgain=18;%dBi
TxCloss=2.5;%dB
TxEiRP=Txpower+TxAgain-TxCloss;%effective isotropic radiated power dBm
A=69.55+26.16*log10(fc)-13.82*log10(hb);
B=44.9-6.55*log10(hb);
D=4.78*(log10(fc))^2+18.33*log10(fc)+40.94;
usrcount=1000;
usrposmat=zeros(usrcount,4);
usrrecpowmat=zeros(usrcount,1);
usrposmat(:,1)=randi([-15000,15000],1,usrcount);
usrposmat(:,2)=randi([-15000,15000],1,usrcount);
usrposmat(:,3)=sqrt(usrposmat(:,1).*usrposmat(:,1)+usrposmat(:,2).*usrposmat(:,2));
pathlossformula=A+B*log10(usrposmat(:,3))-D;
usrrecpowmat=-(pathlossformula-TxEiRP);
usrposmat(:,4)=usrrecpowmat;
