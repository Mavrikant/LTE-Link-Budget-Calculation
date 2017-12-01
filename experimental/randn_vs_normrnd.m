% randn and normrnd are same. 
% if you don't believe me test it yourself.


clc;
clear variables;
close all;

UE_number=1000000
figure (1)
    data=8*randn(UE_number,1);
    mean(data)
    var(data)
    histogram(data);
    
figure (2)
    data=normrnd (0,8,[UE_number,1]);
    mean(data)
    var(data)
    histogram(data);
