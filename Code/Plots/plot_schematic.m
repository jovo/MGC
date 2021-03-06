function [type,dim,noise,n]=plot_schematic(type,dim,noise,n)

% type=1;n=50;dim=1;noise=1;
% CorrSimPlotsA(type,n,dim,noise,pre1);
% Used to generate figure A in the files

%% % File path searching
if nargin<1
    F.type=1;
else
    F.type=type;
end
if nargin<2
    dim=1;
end
if nargin<3
    noise=0.3;
end
if nargin<4
    n=50;
end

fpath = mfilename('fullpath');
fpath=strrep(fpath,'\','/');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-2));
addpath(genpath(strcat(rootDir,'Code/')));

h=figure(1);
clf
set(h,'units','normalized','position',[0 0 1 1])
% figure
try
     load(strcat(rootDir,'Data/Results/CorrFigure1Type',num2str(F.type),'n',num2str(n),'dim',num2str(dim),'.mat')); % The folder to locate data
catch
    display('no file exist, running instead')
    run_fig1Data(F.type,n,dim,noise);
    load(strcat(rootDir,'Data/Results/CorrFigure1Type',num2str(F.type),'n',num2str(n),'dim',num2str(dim),'.mat')); % The folder to locate data
end


%% plotting parameters

cmap=zeros(2,3);
% map3 = map2(size(map2,1)/2+1:end,:);


% optimal scales
indP=optimalInd;
[J,I]=ind2sub(size(pMLocal),indP);

C=squareform(pdist(x));
D=squareform(pdist(y));

[~,~,RC,RD]=MGCDistTransform(C,D,'mcor');

% RC=DistRanks(C);
% RD=DistRanks(D)';
RC=(RC<=k);
RD=(RD<=l);
R2=RC&RD;%&(C_MGC>=0);

%% Figure Structure
F.subplot=true;
if F.subplot==false
    F.fontSize=16;
    F.mkSize=12;
    F.fontSize2=16;
    F.tfs=16;
else
    F.fontSize=8;
    F.mkSize=6;
    F.fontSize2=8;
    F.tfs=8;
end
F.k=k;
F.l=l;

F.Ymin=min(I)-1;
F.Ymax=max(I)-1;
F.Xmin=min(J)-1;
F.Xmax=max(J)-1;

% colors
map3 = brewermap(128,'PiYG'); % brewmap
F.loca=map3(100,:);
F.mgc=F.loca;
F.col=[0 0 0];
F.gray = [0.5,0.5,0.5];
F.glob=[0.5,0.5,0.5];
F.map2 = brewermap(128,'PiYG'); % brewmap
F.map4 = brewermap(128,'BuPu'); % brewmap
F.test=test;
F.tA=tA;
F.type=type;

gr=F.map2(120,:);
pu=F.map2(8,:);
cmap(1,:) = pu;
cmap(2,:) = gr;
% F.map1=cmap;
F.map1= brewermap(128,'BuPu'); % brewmap
set(groot,'defaultAxesColorOrder',F.map1);

if type~=8
    I=2;J=4;J2=n;
else
    I=20;J=22;J2=n-5;
end
F.id=[I,J,J2,J];
F.id2=[1,2,3,2];

if abs(y(F.id(1),1)-y(F.id(2),1))/(max(y(:,1))-min(y(:,1)))<0.1
    F.hy=[+5,-5,0]/100*(max(y(:,1))-min(y(:,1)));
else
    F.hy=zeros(3,1);
end
F.hs=2/100*(max(x(:,1))-min(x(:,1)));

% if type == 1, F.AB='A'; else F.AB='B'; end
F.AB='';

height=0.35;
vspace=0.15;

width=0.48;
left=0.2;
%left=width+left1;
bottom=nan(1,4);
bottom1=0.1;
for i=1:4
    bottom(i)=bottom1+(i-1)*(height+vspace);
end
bottom(4)=bottom(4)+0.15;
bottom(3)=bottom(3)+0.15;
bottom(2)=bottom(2)+0.05;
bottom(1)=0.08;

F.pos =[left, bottom(4), width, height];
F.pos2=[left, bottom(3), width, height];
F.pos3=[left, bottom(2), width, height];
F.pos4=[left, bottom(1), width, height];
% F.pos5=[left, bottom(1), width, height];

F.tit=0;
pre2=strcat(rootDir,'Figures/');% The folder to save figures
donzo=1;
if donzo==1
    F.fname=strcat(pre2, 'Fig',num2str(F.type));
else
    F.fname=strcat(pre2, 'Auxiliary/A3_type', num2str(F.type),'_n', num2str(n), '_noise', num2str(round(noise*10)),'_dim',num2str(dim));
end
F.wh=[2 9];
F.PaperPositionMode='auto';

%% plot panels
mxc=max(max(C));
mxd=max(max(D));
C=C/mxc;
D=D/mxd;
x=x/mxc;
y=y/mxd;
% 1: samle data
F.sub=1;
% F.svg=1;
% F.pdf=1;
if F.subplot==false;
    F.wh=[3.68 4];
end
plot_panel1(F,x,y,R2)      

% 2: Pairwise Distances
F.sub=2;
plot_panel2(F,C,D)      

% 3: only local pairwise distances
F.pos2=F.pos3;
F.sub=3;
plot_panel3(F,C,D);

% 4. Multiscale P-Value Map
F.sub=4;
plot_panel5(F,pMLocal,pMGC) 


% title
if F.subplot==true;
    titletext=CorrSimuTitle(F.type);
%     if F.type==1;
        titletext=strcat(titletext);
%     else
%         titletext=strcat(titletext);
%     end
    h=suptitle(titletext);
    set(h,'FontSize',F.fontSize2+4,'Units', 'normalized','Position', [0.44, -0.08,0], 'HorizontalAlignment', 'center')
    %%
    print_fig(gcf,F)
end