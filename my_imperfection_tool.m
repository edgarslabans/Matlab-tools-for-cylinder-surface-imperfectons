% Matlab script for plotting of imperfection values in 2D figure
% created by Edgars Labans 2017

clc;
clear;
close all;

%Input file  in the format of {theta[rad], z[mm] and Imperfection[mm]} 
filename = 'ExampleInput.txt';


minColorbarVal = -1.0;     % max and min values on the colorbar
maxColorbarVal = 1.0;
markerSize = 30;           % marker size of the dot
numDelete = 0;             % number of peak  values to delete from input


A =importdata(filename);


Theta = A(:,1);
Z = A(:,2)+20;
Imperfect = A(:,3);




% delete necessary number peak values of min, max 
for i=1:numDelete
    [M, I] = max(Imperfect);
    Imperfect(I,:)=[];
    Z(I,:)=[];
    Theta(I,:)=[];
end

for i=1:numDelete
    [M, I] = min(Imperfect);
    Imperfect(I,:)=[];
    Z(I,:)=[];
    Theta(I,:)=[];
end


%converting radians to degrees
Theta = rad2deg(Theta)+180;


% determining max and min values of the colorbar
minValue = min(Imperfect);
maxValue = max(Imperfect);
mid=(maxValue+minValue)/2;


c = Imperfect;
%c = (Imperfect-mid)/15275; % In the case of laser scanner

% plotting points
figure('rend','painters','pos',[10 10 900 600])
colormap jet
scatter(Theta,Z,markerSize,c,'filled')  

% plotting the dots in the given x and y range
xlim([-10 365])
ylim([0 800])

% adding unit values
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [0 45 90 135 180 225 270 315 360])
set(gca, 'Xticklabels',({'270','225','180','135','90','45','0','315','270'}))

% adding labels and style

xhandle = xlabel('Circumferential coordinate, rad');
%set(xhandle,'Fontsize',16);

yhandle = ylabel('Longitudinal coordinate, mm');
%set(yhandle,'Fontsize',16);

colorbar
caxis([minColorbarVal maxColorbarVal])       % max colorbar values

annotation('textbox','String',{'W, mm'},'LineStyle','none',...
    'Position',[0.8428 0.77 0.1013 0.06079]);


pbaspect([2 1 1])

