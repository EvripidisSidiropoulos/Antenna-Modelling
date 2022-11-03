%**************************************************************************
%                       Antenna Analysis using NEC
%                            Discone Antenna
%                         Evripidis Sidiropoulos
%**************************************************************************

clc; clear all;

wl = 1.5;                        % Wave Length
N = 8;                           % Number of Wires
r = 0.25*wl;                     % Ground Disc Radius
l = 0.3*wl;                      % Wire Length
th = pi/6;                       % Antenna Apperture
phi = 2*pi/N;                    % Angle between Wires


wd = wl/750;                     % Wire Diameter, chosen deliberately << wl
d = wl/20;                       % Distance between Ground Disc 
                                 % and Antenna Wires

f0 = (3*10^8)/((10^6)*wl);       % Central Frequency in MHz
f1 = 0.5*f0;                     % Lowest Frequency in MHz
f2 = 4*f0;                       % Highest Frequency in MHz

z = l*cos(th);                   % z coordinate for the start of the 
                                 % conical part,chosen deliberately

A = zeros(17, 9);                % Array of the whole Antenna Geometry
B = zeros(17, 2);                % Array that contains 2 columns 
                                 % for x1 and y1 which are zero
                            
for i = 1:17
    for j = 1:9
        A(i, 1) = i;             % Column 1 contains the tag of each
                                 % element
                                 
        A(1:16, 2) = 20;         % Column 2 contains number of segmenents
                                 % except for feed wire
                                 
        A(17, 2) = 1;            % Feed wire segment, it's asked to be one
        
        A(1:17, 3:4) = B;        % x1 and y1 coordinates for the start of 
                                 % the conical part, which are zero
        A(1:8, 5) = z;           % z1 coordinate for the start of the 
                                 % conical part (it's the same for all
                                 % wires)
        A(9:17, 5) = z + d;      % z1 coordinate for the center of the
                                 % ground disc (it's the same for all wires
                                 % plus the feed of the antenna wire)
                                 
        A(j:8, 6) = l*cos(j*phi)*sin(pi-th); % x2 coordinate for the 
                                             % end of the wires       
        A(j+8:16, 6) = r*cos(j*pi/4);        % x2 coordinate for the 
                                             % ground disc
        A(j:8, 7) = l*sin(j*phi)*sin(pi-th); % y2 coordinate for the 
                                             % end of the wires
        A(j+8:16, 7) = r*sin(j*pi/4);        % y2 coordinate for the
                                             % ground disc
        A(j:8, 8) = l*cos(th) - l*sin(th);   % z2 coordinate for the
                                             % end of the wires   
        A(9:16, 8) = z + d;                  % z2 coordinate for the 
                                             % ground disc
        
        A(17, 6) = 0;                        % x2 coordinate for the
                                             % end of feed
        A(17, 7) = 0;                        % y2 coordinate for the
                                             % end of feed
        A(17, 8) = z;                        % z2 coordinate for the
                                             % end of feed 
        A(i, 9) = wd;            % Column 9 contains the radius of each
                                 % element                                     
    end
end

disp(A);                                     % Display of Array A

formatSpec = 'GW %2d %2d %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f\n';
fileID = fopen('DisconeAntenna.nec', 'w');   % Open NEC File for Writing
fprintf(fileID, 'CM Antenna Analysis using NEC\n'); % Print NEC Comment
fprintf(fileID, 'CM Discone Antenna\n');            % Print NEC Comment
fprintf(fileID, 'CM Evripidis Sidiropoulos\n');     % Print NEC Comment
fprintf(fileID, 'CE \n');                           % Print NEC Comment
fprintf(fileID, formatSpec, A');             % Print Antenna Geometry  
fprintf(fileID, 'GE 0\n');                   % Print NEC Command for
                                             % End of Geometry
fprintf(fileID, 'EX 0 17 1 0 1 0\n');        % Print NEC Command for 
                                             % Voltage on feed wire
fprintf(fileID, 'FR 0 1 0 0 %d', f0);        % Print NEC Command for 
                                             % Frequency inputs
fprintf(fileID, ' 0\n');                     % Print NEC Command for 
                                             % Frequency inputs                                                
fprintf(fileID, 'EN');                       % Print NEC Command for
                                             % End of File
fclose(fileID);                              % Close NEC File