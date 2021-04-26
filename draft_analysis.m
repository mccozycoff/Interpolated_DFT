clear all, close all, clc

% generacja sygnalu testowego
% jesli F0/Fs*n nie jest parzyste calkowite to probkowanie jest niekoherentne 
F0 = 70; % [Hz] , czestotliwosc sygnalu analogowego
F1 = 50;
Fs = 500; % [Hz] , czestotliwosc probkowania
A1 = 1.2; % [-], amplituda sygnalu
A2 = 0;
A3 = 0; % randn noise amplitude
phi = 1.2; % [rad], faza poczatkowa sygnalu
n = 64; % [-], liczba probek sygnalu
w0 = 2*pi()*F0/Fs;
w1 = 2*pi()*F1/Fs;
X = A1*cos(w1*[0:1:(n-1)]' + phi*ones(n,1)) + A2*cos(w0*[0:1:(n-1)]' + phi*ones(n,1))+ ...
    A3*randn(n,1); % [-] sygnal testowy 




%okno
d = n; % szerokosc okna
M=1;
alpha = 2*M; % rzad zastosowanego okna RVCI 

W = RVC1(d,M);

% FT, DFT
V = W.*X(1:d,1); % okienkowanie sygnalu testowego X

% Implementacja FT (ciagle widmo sygnalu dyskretnego)
k = 1;
for w = 0:0.001:2*pi()
    Xw(k,1) = sum(V.*exp(-1*j*w*[0:1:(d-1)]'));
    k = k+1;
end 
Xw = Xw/length(V);

figure(1)
w = [0:0.001:2*pi()]; % wektor ciaglej dziedziny czestotliwosci [rad]
plot(Fs/2/pi()*w,2*abs(Xw));
hold on;


Xk = fft(V)/d;
wk = Fs/d*[0:1:(d-1)]'; % wektor dyskretnej dziedziny czestotliwosci [rad]
figure(1)

stem(wk, 2*abs(Xk),'ro');  % dyskretne widmo sygnalu dyskretnego (DFT)

% IpDFT

[w_delta,phi_delta, V_delta] = IpDFT(2,M,Xk);

figure(1)
stem(Fs*w_delta/2/pi(),V_delta,'gx');

ax = gca;
ax.XLim = [0 Fs/2];
grid on;
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [-]');

figure(2)
stem([0:1:(n-1)]/Fs,X, '-o');
ax = gca;
ax.XLim = [0,(n-1)/Fs];
grid on;
xlabel('Czas [s]');
ylabel('Amplituda [-]');


w = find(abs(Xk) == max(abs(Xk)));
w = w(1);
phi_v = angle(Xk(w))
