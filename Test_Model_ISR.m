% Test_Model_ISR.m
%
% Script to Test ISR Simulator with Multiple Ion Species
%
% -------------------------------------------------------------------------
% Author: Miguel Martínez Ledesma (University of Chile)  
% Email: miguel.martinez@ing.uchile.cl
% Date: 16 February 2016
% -------------------------------------------------------------------------

%% LIBRARIES

% Incoherent Scatter Radar Model Path.-
addpath('Model_ISR')

%% TIME COUNT

tic();

%% PARAMETERS CONFIGURATION

NumPoints=6;

% Sweep for molecular ion fraction
Te=2000;
Ti=1000;
Ne=1e11;
Ve=0;
Vi=0;
MolecularIonFraction=linspace(0,1,NumPoints);

Ni_O=Ne*(1-MolecularIonFraction);
Ni_NO=Ne*(MolecularIonFraction);

%% RADAR CONFIGURATION

radarFreq = 450e6;
freqMax =  10e3;
freqMin = -10e3;
freqPoints = 1000;

%Initialize
configuration=init_ISR_simulator(radarFreq, freqMin, freqMax, freqPoints);

%Add Ion Species
configuration=addSpecie_ISR_simulator(configuration,'O+');
configuration=addSpecie_ISR_simulator(configuration,'NO+');

%Electrons configuration
configuration=changeSpecie_ISR_simulator(configuration, 'E-', Ne, Te, Ve);

%Ions configuration
configuration=changeSpecie_ISR_simulator(configuration, 'O+', Ni_O, Ti, Vi);
configuration=changeSpecie_ISR_simulator(configuration, 'NO+', Ni_NO, Ti, Vi);

%% TIME COUNT

secondselapsed = toc();
fprintf('Time Elapsed (configurations): %.2f [sec]\n', secondselapsed);

%% ISR SIMULATION

spectrum = ISR_simulator(configuration);
w = configuration.omega;
Num = size(spectrum);

%% TIME COUNT

secondselapsed = toc();
fprintf('Time Elapsed (%i spectrums): %.2f [sec]\n', Num(2), secondselapsed);

%% GRAPHICS

colors = ' rgbcyk';
legendString={};

figure(1)
hold on
grid on
box on

for i = 1:Num(2)
    plot(w/(2*pi*1e3),(spectrum(:,i)),sprintf('%c-',colors(mod(i,length(colors))+1)),'linewidth',2);
    legendString{i}=sprintf('p=%.1f',MolecularIonFraction(i));
end
xlim([configuration.minFreq configuration.maxFreq]/1000);

xlabel('\omega (kHz) - Frequency');
ylabel('S(\omega) - Spectal Density Function');
title(sprintf('Incoherent Scatter Spectrum (N_e=%.1e T_e=%.0f T_i=%.0f)',Ne,Te,Ti));
legend(legendString)

%% TIME COUNT

secondselapsed = toc();
fprintf('Time Elapsed (graphics): %.2f [sec]\n', secondselapsed);

%% CLOSE LIBRARIES 

% Remove Paths.-
rmpath('Model_ISR')
