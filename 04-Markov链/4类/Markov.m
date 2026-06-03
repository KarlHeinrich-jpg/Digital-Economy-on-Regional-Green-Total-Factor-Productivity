clc
clear

A=xlsread('data','Sheet1');
B=xlsread('data','Sheet2');

%定义类型，这里采用分位数进行定义，若想要自定义则将prctile(A(:),XX)替换为你的自定义分位点
Q1 = prctile(A(:),25);  %小于等于Q1的为类型1
Q2 = prctile(A(:),50);  %小于等于Q2，大于Q1的为类型2
Q3 = prctile(A(:),75);  %小于等于Q3，大于Q2的为类型3；大于Q3的为类型4

tt=1;   %跨期数（滞后期数）
p=trantong_markov(A,tt,Q1,Q2,Q3);
pp=space_markov(A,B,tt,Q1,Q2,Q3);
jieguo=[p;pp]
disp('计算完毕！请查看工作区，jieguo工作表')