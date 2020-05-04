% Matlab code to fit the point cloud to the cylinder geometry
% returns the file with output of {theta[rad], z[mm] and Imperfection[mm]} 
% requires phased array toolbox and computer vision toolbox to execute
% created by Edgars Labans 2018

clc;
clear;
close all;

A = importdata('Input_raw.csv',';',1);

% define the column numbers for variables. Z - longitudinal axis of the
% cylinder
X =  A.data(:,3);
Y =  A.data(:,5);
Z =  A.data(:,4);

P = [X, Y, Z];


% manual rotating the data points around X and Y axis,
% by changing values behind  rotx and roty
P = (rotx(-0.04) * [P(:,1), P(:,2), P(:,3)]')';       % Nontrad rotx(-.09) roty(1.16)
P = (roty(0.16) * [P(:,1), P(:,2), P(:,3)]')';       % trad  rotx(-0.04) roty(0.16)


% centering the data points again
P(:,1) = P(:,1)-(min(P(:,1))+max(P(:,1)))/2;
P(:,2) = P(:,2)-(min(P(:,2))+max(P(:,2)))/2;
P(:,3) = P(:,3)-min(P(:,3));


figure;
scatter3(P(:, 1), P(:, 2), P(:, 3))
axis equal

ptCloud = pointCloud(P);
maxDistance = 0.2;
% fitting cylinder model to the data points
model = pcfitcylinder(ptCloud, maxDistance);
hold on
plot(model)

fprintf('Radius of the cylinder found by best-fit: \n')
model.Radius;
model.Parameters;

% finding the angle of the cylinder axis in respect to global CS
P1 = [model.Parameters(1), model.Parameters(2), model.Parameters(3)];
P2 = [model.Parameters(4), model.Parameters(5), model.Parameters(6)];


%Calculating of the angle for cylinder axis to the vertical axis
basePojection = sqrt((P1(1)-P2(1))^2+(P1(2)-P2(2))^2);
thetaVert = atan2(basePojection,(P1(3)-P2(3)))*(180/pi);
% Calculate projections of this angle to X and Y
thetaBaseX = atan2((P1(1)-P2(1)),(P1(3)-P2(3)))*(180/pi);
thetaBaseY = atan2((P1(2)-P2(2)),(P1(3)-P2(3)))*(180/pi);

% Writing Theta, Imperfection and Z values to file
[theta,rho,z] = cart2pol(P(:,1),P(:,2),P(:,3));
Output = [theta,z,rho-model.Radius];

% Screen output for control purposes
% thetaVert - angle between axis of cylinder and the global vertical axis
% thetaBaseX,thetaBaseY - projection of this angle on global X and Y planes
Angles =  [thetaVert, thetaBaseX,thetaBaseY]
% max, min and abs offset from the perfect cylinder  (smaller the better)
Max_min = [max(Output(:,3)),min(Output(:,3)),abs(max(Output(:,3)))+abs(min(Output(:,3)))]


% write output as table of {theta[rad], z[mm] and Imperfection[mm]} 
% these values are further used for graphical processing
dlmwrite('ForImperfectionTool.txt',Output,'delimiter','\t','precision',7)

% write aligned point cloud in xyz system if necessary
%dlmwrite('Point_cloud_aligned.txt',P,'delimiter','\t','precision',7)


