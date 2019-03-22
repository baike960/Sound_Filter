 
clear, clc      % clear all variables
 
%%  Read in the noisy audio signal from the file 'CapnJ.wav' using audioread function
[Signal_Noisy, Fs] = audioread('yanny.wav');
Signal_Noisy=Signal_Noisy*20;
Signal_Noisy = Signal_Noisy'; % Change to column vector
N = length(Signal_Noisy);
Index = 0:N-1;
 
%%  Play the noisy audio signal using sound function
%sound(Signal_Noisy, Fs), % Play the "Noisy" audio signal
 
%% Plot the time-domain noisy signal 
figure(1), clf
subplot(2,1,1)
plot(Index, Signal_Noisy)
ylabel('Orig. Time Sig. Amp.'),
xlabel('Time (Samples)'),
%title('"Not chess Mr. Spock, ...poker."')
grid on, zoom on
 
%% Obtain and plot the DTFT magnitude of the noisy signal 
% You can use FFT with a very large number of points
% Plot the normalized magnitude in dB (i.e., 20*log10(mag/max(mag))
% Use Hz for the horzontal frequency axis (based on Fs sampling rate
% obtained above)
% Use proper axis limits for your plot
nn=10000;
MaxF=11026;
 
Y=fft(Signal_Noisy,nn);
P2 = abs(Y/nn);
P1 = P2(1:nn/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f= Fs*(0:(nn/2))/nn;
subplot(2,1,2);
plot(f,20*log10(P1/max(P1))); 
title('DTFT of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');
 
%%  Using fir1 function, design a lowpass FIR filter
% You need to select your filter order as well as the desired cut-off
% frequency. 
% For cut-off, try a few values in 2-4KHz range.
% Play with both cut-off and the filter order till you can properly hear and understand the spoken words.  
% Remember that the cut-off frequency input to fir1 is 0<Wn<1 with 1
% corresponding to the Nyquist rate (i.e., Fs/2 Hz or pi rad/sample)
 
F_cutoff =7000/Fs; % Lowpass filter cutoff freq in Hz
FF=3500;
order=100;
B = fir1(order,F_cutoff,'low'); % Simple lowpass FIR coeffs
%% Obtain and plot the filter normalized mag response
% Again, you can use FFT with a large number of points
Bx=fft(B,nn);
P3 = abs(Bx/nn);
P4 = P3(1:nn/2+1);
P4(2:end-1) = 2*P4(2:end-1);
ff= Fs*(0:(nn/2))/nn;
figure;
plot(ff,20*log10(P4/max(P4))); 
title('filter normalized mag response');
xlabel('f (Hz)');
ylabel('|P4(f)|');
 
 
 
%%  Lowpass filter the "Signal_Noisy" using the filter function and the filter you designed above 
 
 
%con=conv(Signal_Noisy, B);
con=filter(B,1,Signal_Noisy); 
 
 
 
%% Obtain and plot the normalized DTFT mag of your filtered signal
con2=fft(con);
len=length(con2);
P5 = abs(con2/len);
P6 = P5(1:(len/2*FF/MaxF)+1);
P6(2:end-1) = 2*P6(2:end-1);
f= Fs*(0:((len/2)*FF/MaxF))/len;
figure;
plot(f,20*log10(P6/max(P6))); 
title('DTFT of filtered signal');
xlabel('f (Hz)');
ylabel('|P4(f)|');
 
 
%% Play the reduced-noise sound using the sound function
sound(con,Fs);
 
 

