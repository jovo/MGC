function []=CorrSimPlots(optionA, total,pre1,pre2)
% Used to plot figure 1-8 used in tex. Run like
% optionA=1;
% CorrSimPlots(optionA)

% optionA can be 1 or 2. Use 1 for paper figures, which include MGC{mcorr} and all global tests;
% use 2 for appendix figures, which will further include MGC{dcorr/Mantel}.
%
% total is usually 20.
% pre1 specifies the location to load data.
% pre2 specifies the location to save pictures.

if nargin<1
    optionA=1; % Use 1 for paper figures, which include MGC{mcorr} and all global tests; use 2 for appendix figures, which will further include MGC{dcorr/Mantel}.
end
if nargin<2
    total=20; % Usually 20, but can be changed in case of new simulations
end
if nargin<3
    pre1='../../Data/'; % The folder to locate data
end
if nargin<4
    pre2='../../Figures/Fig'; % The folder to save figures
end

% Set colors
cmap = brewermap(4,'Dark2');
map1=zeros(7,3);
map1(1,:)=cmap(1,:);map1(4,:)=cmap(1,:); % The color for MGC{mcorr} and global mcorr.
map1(2,:)=cmap(2,:);map1(5,:)=cmap(2,:); % The color for MGC{dcorr} and global dcorr.
map1(3,:)=cmap(3,:);map1(6,:)=cmap(3,:); % The color for MGC{Mantel} and global Mantel.
map1(7,:)=cmap(4,:); % The color for HHG
if optionA==1
    map1=map1([1,4:7],:); % Take out MGC{dcorr} and MGC{Mantel} color when they are not needed.
end
map2 = brewermap(128,'GnBu'); % brewmap

%figure1-4
figNumber='1';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure('units','normalized','position',[0 0 1 1])
set(groot,'defaultAxesColorOrder',map1);
s=4;
t=5;
for j=1:total
    filename=strcat(pre1,'CorrIndTestType',num2str(j),'N100Dim1.mat');
    load(filename)
    subplot(s,t,j)
    titlechar=CorrSimuTitle(j);
    switch optionA
        case 1
            plot(numRange,power1,'.-',numRange,power4,'.: ',numRange,power5,'.:',numRange,power6,'.:',numRange,power7,'.:','LineWidth',2);
        case 2
            plot(numRange,power1,'.-',numRange,power2,'.-',numRange,power3,'.-',numRange,power4,'.:',numRange,power5,'.:',numRange,power6,'.:',numRange,power7,'.:','LineWidth',2);
    end
    xlim([numRange(1) numRange(end)]);
    ylim([0 1]);
    if j~=16 % Remove x&y axis ticks except type 16, which is at the left bottom
        set(gca,'XTick',[]); % Remove x axis ticks
        set(gca,'YTick',[]); % Remove y axis ticks
    end
    title(titlechar);
end
xlabel('Sample Size','position',[-200 -0.2],'FontSize',20);
ylabel('Empirical Testing Power','position',[-515 3],'FontSize',20);
h=suptitle('Testing Powers of 20 Simulated Dependencies for Dimension 1 with Increasing Sample Size');
set(h,'FontSize',20,'FontWeight','normal');
lgdPosition = [0.03, 0.87, .07, .07]; %Legend Position
switch optionA
    case 1
        h=legend('MGC','mcorr','dcorr','Mantel','HHG','Location',lgdPosition);
    case 2
        h=legend('MGC\{mcorr\}','MGC\{dcorr\}','MGC\{Mantel\}','mcorr','dcorr','Mantel','HHG','Location',lgdPosition);
end
set(h,'FontSize',12);
%
F.fname=strcat(pre2, figNumber);
F.wh=[8 4]*2;
print_fig(gcf,F)

%
figNumber='2';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure('units','normalized','position',[0 0 1 1])
s=4;
t=5;
for j=1:total
    filename=strcat(pre1,'CorrIndTestType',num2str(j),'N100Dim1.mat');
    load(filename)
    subplot(s,t,j)
    titlechar=CorrSimuTitle(j);
    K=n;kmin=1;thres=0.8;
    if optionA==1
        ind=[find(max(power1,[],1)>=thres,1) lim];
    else
        ind=[find(max(power3,[],1)>=thres,1) lim];
    end
    lim=min(ind);
    kmin=2;
    if optionA==1
        ph=power1All(kmin:numRange(lim),kmin:numRange(lim),lim)';
    else
        ph=power3All(kmin:numRange(lim),kmin:numRange(lim),lim)';
    end
    imagesc(ph);
    set(gca,'YDir','normal')
    colormap(map2)
    caxis([0 thres])
    set(gca,'XTick',[]); % Remove x axis ticks
    set(gca,'YTick',[]); % Remove y axis ticks
    title(titlechar);
end
xlabel('Neighborhood Choice of X','position',[-200 -20],'FontSize',20);
ylabel('Neighborhood Choice of Y','position',[-535 300],'FontSize',20);
colorbar
if optionA==1
    tstring=' of mcorr ';
else
    tstring=' of Mantel ';
end
h=suptitle(strcat('Testing Powers of All Local Tests',tstring, ' for Dimension 1'));
set(h,'FontSize',20,'FontWeight','normal');
%
F.fname=strcat(pre2, figNumber);
F.wh=[8 4]*2;
print_fig(gcf,F)

%%%performance profile
figNumber='3';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure
set(groot,'defaultAxesColorOrder',map1)
a=0;b=1;interval=0.01;
xaxis=a:interval:b;
profile=zeros(7,length(xaxis));
%load data
for j=1:total
    filename=strcat(pre1,'CorrIndTestType',num2str(j),'N100Dim1.mat');
    load(filename)
    thres=0.8;
    ind=[find(power1>=thres,1) find(power4>=thres,1) find(power5>=thres,1) find(power6>=thres,1) find(power7>=thres,1) lim];
    pos=min(ind);
    switch optionA
        case 1
            power=[power1(pos), power4(pos), power5(pos), power6(pos),power7(pos)];
        case 2
            power=[power1(pos), power2(pos), power3(pos), power4(pos),power5(pos),power6(pos),power7(pos)];
    end
    pmax=max(power);
    for k=1:length(power)
        tmp=(pmax-power(k));
        tmpInd=ceil(tmp/interval)+1;
        profile(k,tmpInd:end)=profile(k,tmpInd:end)+1;
    end
end
profile=profile./total;
sumP=ceil(mean(profile,2)*1000)/1000;
switch optionA
    case 1
        plot(xaxis,profile(1,:),'.-',xaxis,profile(2,:),'.:',xaxis, profile(3,:),'.:',xaxis,profile(4,:),'.:',xaxis,profile(5,:),'.:','LineWidth',2);
        h=legend(strcat('MGC, AUC=', num2str(sumP(1))),strcat('mcorr, AUC=', num2str(sumP(2))),strcat('dcorr, AUC=', num2str(sumP(3))),strcat('Mantel, AUC=', num2str(sumP(4))),strcat('HHG, AUC=', num2str(sumP(5))),'Location','SouthEast');
    case 2
        plot(xaxis,profile(1,:),'.-',xaxis,profile(2,:),'.-',xaxis,profile(3,:),'.-',xaxis,profile(4,:),'.:',xaxis, profile(5,:),'.:',xaxis,profile(6,:),'.:',xaxis,profile(7,:),'.:','LineWidth',2);
        h=legend(strcat('MGC\{mcorr\}, AUC=', num2str(sumP(1))),strcat('MGC\{dcorr\}, AUC=', num2str(sumP(6))),strcat('MGC\{Mantel\}, AUC=', num2str(sumP(7))),strcat('mcorr, AUC=', num2str(sumP(2))),strcat('dcorr, AUC=', num2str(sumP(3))),strcat('Mantel, AUC=', num2str(sumP(4))),strcat('HHG, AUC=', num2str(sumP(5))),'Location','SouthEast');
end
set(h,'FontSize',12);
xlabel('Difference with the Best Method','FontSize',16);
ylabel('Relative Performance','FontSize',16);
ylim([0 1]);
titleStr = strcat('Performance Profiles for Dimension 1');
title(titleStr,'FontSize',12);
%
F.fname=strcat(pre2, figNumber);
F.wh=[3 2.5]*2;
print_fig(gcf,F)

%%%performance profile AUC for n
figNumber='4';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure
set(groot,'defaultAxesColorOrder',map1)
a=0;b=1;interval=0.01;
xaxis=a:interval:b;
limN=10;
sumP=zeros(7,limN);
%load data
for ll=1:limN
    profile=zeros(7,length(xaxis));
    thres=ll/limN;
    for j=1:total
        filename=strcat(pre1,'CorrIndTestType',num2str(j),'N100Dim1.mat');
        load(filename)
        ind=[find(power1>=thres,1) find(power4>=thres,1) find(power5>=thres,1) find(power6>=thres,1) find(power7>=thres,1) lim];
        pos=min(ind);
        switch optionA
            case 1
                power=[power1(pos), power4(pos), power5(pos), power6(pos),power7(pos)];
            case 2
                power=[power1(pos), power2(pos), power3(pos), power4(pos),power5(pos),power6(pos),power7(pos)];
        end
        pmax=max(power);
        for k=1:length(power)
            tmp=(pmax-power(k));
            tmpInd=ceil(tmp/interval)+1;
            profile(k,tmpInd:end)=profile(k,tmpInd:end)+1;
        end
    end
    profile=profile./total;
    sumP(:,ll)=ceil(mean(profile,2)*1000)/1000;
end
xaxis=1/limN:1/limN:1;
switch optionA
    case 1
        plot(xaxis,sumP(1,:),'.-',xaxis, sumP(2,:),'.:',xaxis,sumP(3,:),'.:',xaxis, sumP(4,:),'.:',xaxis,sumP(5,:),'.:','LineWidth',2);
        h=legend('MGC','mcorr','dcorr','Mantel','HHG','Location','SouthEast');
    case 2
        plot(xaxis,sumP(1,:),'.-',xaxis,sumP(2,:),'.-',xaxis,sumP(3,:),'.-',xaxis, sumP(4,:),'.:',xaxis,sumP(5,:),'.:',xaxis, sumP(6,:),'.:',xaxis,sumP(7,:),'.:','LineWidth',2);
        h=legend('MGC\{mcorr\}','MGC\{dcorr\}','MGC\{Mantel\}','mcorr','dcorr','Mantel','HHG','Location','SouthEast');
end
set(h,'FontSize',12);
xlabel('Threshold of Power','FontSize',16);
ylabel('Area Under Curve','FontSize',16);
ylim([0 1]);
titleStr = strcat('Area Under Curve of Performance Profiles for Dimension 1');
title(titleStr,'FontSize',12);
%
F.fname=strcat(pre2, figNumber);
F.wh=[3 2.5]*2;
print_fig(gcf,F)


%Plot 5-8
figNumber='5';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure('units','normalized','position',[0 0 1 1])
set(groot,'defaultAxesColorOrder',map1)
s=4;
t=5;
for j=1:total
    filename=strcat(pre1,'CorrIndTestDimType',num2str(j),'N100Dim.mat');
    load(filename)
    numRange=dimRange;
    subplot(s,t,j)
    titlechar=CorrSimuTitle(j);
    switch optionA
        case 1
            plot(numRange,power1,'.-',numRange,power4,'.: ',numRange,power5,'.:',numRange,power6,'.:',numRange,power7,'.:','LineWidth',2);
        case 2
            plot(numRange,power1,'.-',numRange,power2,'.-',numRange,power3,'.-',numRange,power4,'.:',numRange,power5,'.:',numRange,power6,'.:',numRange,power7,'.:','LineWidth',2);
    end
    xlim([numRange(1) numRange(end)]);
    ylim([0 1]);
    if j~=16 % Remove x&y axis ticks except type 16, which is at the left bottom
        set(gca,'XTick',[]); % Remove x axis ticks
        set(gca,'YTick',[]); % Remove y axis ticks
    end
    title(titlechar);
end
xlabel('Dimension','position',[-180 -0.2],'FontSize',20);
ylabel('Empirical Testing Power','position',[-480 3],'FontSize',20);
h=suptitle('Testing Powers of 20 Simulated Dependencies for Increasing Dimension with Fixed Sample Size');
set(h,'FontSize',20,'FontWeight','normal');
lgdPosition = [0.03, 0.87, .07, .07]; %Legend Position
switch optionA
    case 1
        h=legend('MGC','mcorr','dcorr','Mantel','HHG','Location',lgdPosition);
    case 2
        h=legend('MGC\{mcorr\}','MGC\{dcorr\}','MGC\{Mantel\}','mcorr','dcorr','Mantel','HHG','Location',lgdPosition);
end
set(h,'FontSize',12);
%
F.fname=strcat(pre2, figNumber);
F.wh=[8 4]*2;
print_fig(gcf,F)


figNumber='6';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure('units','normalized','position',[0 0 1 1])
s=4;
t=5;
for j=1:total
    filename=strcat(pre1,'CorrIndTestDimType',num2str(j),'N100Dim.mat');
    load(filename)
    subplot(s,t,j)
    titlechar=CorrSimuTitle(j);
    kmin=1;thres=0.5;
    if optionA==1;
        ind=[find(max(power1,[],1)>=thres,1,'last'),1];
    else
        ind=[find(max(power3,[],1)>=thres,1,'last'),1];
    end
    lim=max(ind);
    if optionA==1
        ph=power1All(kmin:n,kmin:n,lim)';
    else
        ph=power3All(kmin:n,kmin:n,lim)';
    end
    imagesc(ph);
    set(gca,'YDir','normal')
    colormap(map2)
    caxis([0 thres])
    set(gca,'XTick',[]); % Remove x axis ticks
    set(gca,'YTick',[]); % Remove y axis ticks
    title(titlechar);
end
xlabel('Neighborhood Choice of X','position',[-200 -25],'FontSize',20);
ylabel('Neighborhood Choice of Y','position',[-535 300],'FontSize',20);
colorbar
if optionA==1
    tstring=' of mcorr ';
else
    tstring=' of Mantel ';
end
h=suptitle(strcat('Testing Powers of All Local Tests',tstring,' for Increasing Dimension'));
set(h,'FontSize',20,'FontWeight','normal');
%
F.fname=strcat(pre2, figNumber);
F.wh=[8 4]*2;
print_fig(gcf,F)

%%%performance profile
figNumber='7';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure
set(groot,'defaultAxesColorOrder',map1)
a=0;b=1;interval=0.01;
xaxis=a:interval:b;
profile=zeros(7,length(xaxis));
%load data
for j=1:total
    filename=strcat(pre1,'CorrIndTestDimType',num2str(j),'N100Dim.mat');
    load(filename)
    thres=0.5;
    ind=[find(power1>=thres,1,'last') find(power4>=thres,1,'last') find(power5>=thres,1,'last') find(power6>=thres,1,'last') find(power7>=thres,1,'last') 1];
    pos=max(ind);
    switch optionA
        case 1
            power=[power1(pos), power4(pos), power5(pos), power6(pos),power7(pos)];
        case 2
            power=[power1(pos), power2(pos), power3(pos), power4(pos),power5(pos),power6(pos),power7(pos)];
    end
    pmax=max(power);
    for k=1:length(power)
        tmp=(pmax-power(k));
        tmpInd=ceil(tmp/interval)+1;
        profile(k,tmpInd:end)=profile(k,tmpInd:end)+1;
    end
end
profile=profile./total;
sumP=ceil(mean(profile,2)*1000)/1000;
switch optionA
    case 1
        plot(xaxis,profile(1,:),'.-',xaxis,profile(2,:),'.:',xaxis, profile(3,:),'.:',xaxis,profile(4,:),'.:',xaxis,profile(5,:),'.:','LineWidth',2);
        h=legend(strcat('MGC, AUC=', num2str(sumP(1))),strcat('mcorr, AUC=', num2str(sumP(2))),strcat('dcorr, AUC=', num2str(sumP(3))),strcat('Mantel, AUC=', num2str(sumP(4))),strcat('HHG, AUC=', num2str(sumP(5))),'Location','SouthEast');
    case 2
        plot(xaxis,profile(1,:),'.-',xaxis,profile(2,:),'.-',xaxis,profile(3,:),'.-',xaxis,profile(4,:),'.:',xaxis, profile(5,:),'.:',xaxis,profile(6,:),'.:',xaxis,profile(7,:),'.:','LineWidth',2);
        h=legend(strcat('MGC\{mcorr\}, AUC=', num2str(sumP(1))),strcat('MGC\{dcorr\}, AUC=', num2str(sumP(6))),strcat('MGC\{Mantel\}, AUC=', num2str(sumP(7))),strcat('mcorr, AUC=', num2str(sumP(2))),strcat('dcorr, AUC=', num2str(sumP(3))),strcat('Mantel, AUC=', num2str(sumP(4))),strcat('HHG, AUC=', num2str(sumP(5))),'Location','SouthEast');
end
set(h,'FontSize',12);
xlabel('Difference with the Best Method','FontSize',16);
ylabel('Relative Performance','FontSize',16);
ylim([0 1]);
titleStr = strcat('Performance Profiles for Increasing Dimension');
title(titleStr,'FontSize',12);
%
F.fname=strcat(pre2, figNumber);
F.wh=[3 2.5]*2;
print_fig(gcf,F)

%%%performance profile
figNumber='8';
if optionA~=1
    figNumber=strcat(figNumber,'b');
end
figure
set(groot,'defaultAxesColorOrder',map1)
a=0;b=1;interval=0.01;
xaxis=a:interval:b;
limN=10;
sumP=zeros(7,limN);
%load data
for ll=1:limN
    profile=zeros(7,length(xaxis));
    thres=ll/limN;
    for j=1:total
        filename=strcat(pre1,'CorrIndTestDimType',num2str(j),'N100Dim.mat');
        load(filename)
        ind=[find(power1>=thres,1,'last') find(power4>=thres,1,'last') find(power5>=thres,1,'last') find(power6>=thres,1,'last') find(power7>=thres,1,'last') 1];
        pos=max(ind);
        switch optionA
            case 1
                power=[power1(pos), power4(pos), power5(pos), power6(pos),power7(pos)];
            case 2
                power=[power1(pos), power2(pos), power3(pos), power4(pos),power5(pos),power6(pos),power7(pos)];
        end
        pmax=max(power);
        for k=1:length(power)
            tmp=(pmax-power(k));
            tmpInd=ceil(tmp/interval)+1;
            profile(k,tmpInd:end)=profile(k,tmpInd:end)+1;
        end
    end
    profile=profile./total;
    sumP(:,ll)=ceil(mean(profile,2)*1000)/1000;
end
xaxis=1/limN:1/limN:1;
switch optionA
    case 1
        plot(xaxis,sumP(1,:),'.-',xaxis, sumP(2,:),'.:',xaxis,sumP(3,:),'.:',xaxis, sumP(4,:),'.:',xaxis,sumP(5,:),'.:','LineWidth',2);
        h=legend('MGC','mcorr','dcorr','Mantel','HHG','Location','SouthEast');
    case 2
        plot(xaxis,sumP(1,:),'.-',xaxis,sumP(2,:),'.-',xaxis,sumP(3,:),'.-',xaxis, sumP(4,:),'.:',xaxis,sumP(5,:),'.:',xaxis, sumP(6,:),'.:',xaxis,sumP(7,:),'.:','LineWidth',2);
        h=legend('MGC\{mcorr\}','MGC\{dcorr\}','MGC\{Mantel\}','mcorr','dcorr','Mantel','HHG','Location','SouthEast');
end
set(h,'FontSize',12);
xlabel('Threshold of Power','FontSize',16);
ylabel('Area Under Curve','FontSize',16);
ylim([0 1]);
titleStr = strcat('Area Under Curve of Performance Profiles for Increasing Dimension');
title(titleStr,'FontSize',12);
%
F.fname=strcat(pre2, figNumber);
F.wh=[3 2.5]*2;
print_fig(gcf,F)