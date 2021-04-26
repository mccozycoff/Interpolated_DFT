function [ w_delta, phi_delta, V_delta ] = IpDFT(p,M,V)
% Interpolowane DFT korygujące częstotliwość, amplitudę oraz fazę 
% wyznaczonych prążków widma V sygnału
%% Argumenty wywołania: 
% p - wybor metody : 2 - dwupunktowa , 3 - trzypunktowa
% M - rzad okna RVCI użytego przy okienkowaniu badanego sygnału
% V - wektor widma dyskretnego (DFT) badanego sygnału okienkowanego
%% Dane zwracane
% w_delta - skorygowana estymata częstotliwości badanego sygnału
% phi_delta - skorygowana estymata fazy badanego sygnału
% V_delta - estymata amplitudy prążka o skorygowanej częstotliwości


%% Sprawdzenie poprawności argumentów wywołania funkcji
if(p ~= 2 && p ~= 3)
    error('Please provide value of p from {2,3} set');
end
 
if(M <0 || M~= round(M) || M >6)
    error('Please provide value of M from {0,1,...6} set');
end

%% Wyznaczenie indeksów prążków o trzech największych amplitudach 
k = find(abs(V(1:length(V)/2)) == max(abs(V(1:length(V)/2))));
k = k(1);
if(k==1) %(dostepna tylko metoda dwupunktowa)
    kp = k+1;
    if(p==3)
        disp('Only 2-point IpDFT available for this dataset');
        p = 2;
    end
else if ( abs(V(k+1)) > abs(V(k-1)) )
        kp = k+1;
        kpp = k-1;
    else 
        kp = k-1;
        kpp = k+1;
    end 
end

%% Współczynniki dla okien RVCI
Am = [1 0 0 0 0 0 0; 1 1 0 0 0 0 0; 1 4/3 1/3 0 0 0 0; 1 3/2 3/5 1/10 0 ...
    0 0; 1 8/5 4/5 8/35 1/35 0 0; 1 105/63 60/63 45/126 5/63 1/126 0; ...
    1 396/231 495/462 110/231 33/231 6/231 1/462]';


if (p == 2) % dla p = 2 metoda dwupunktowa IpDFT
    delta = ((M + 1)*abs(V(kp)) - M*abs(V(k)))/...
        (abs(V(k))+ abs(V(kp))); % (20)
    w_delta = (k-1 + (kp-k)*delta)*2*pi()/length(V); % (13)
    phi_delta = angle(V(k)) + ...
        (kp-k)*angle(exp(-j*delta*(pi()/length(V))*(length(V)-1))); % (19)
    Sk = 0; % Suma pomocnicza (24)
    for m = -M:1:M
        if (m == 0)
            Sk = Sk + (-1)^(m)*Am(1,M+1)/(delta-m);
        else
            Sk = Sk + (-1)^(m)*Am(abs(m)+1,M+1)/2/(delta- m);
        end
    end
    Sk = abs(Sk);
    V_delta = abs(V(k))*2*pi()/sin(delta*pi())/Sk; % (21)
          
else % p == 3
    if(M ~= 0)
        delta = (M+1)*(abs(V(kp))-(abs(V(kpp))))...
            /(2*abs(V(k))+abs(V(kpp))+abs(V(kp))); % (22)
    else % okno prostokątne
        delta = (abs(V(kp))+(abs(V(kpp))))/...
            (2*abs(V(k))-abs(V(kpp))+abs(V(kp)));
        V_delta = 2*abs(V(k));
    end
    w_delta = (k-1 + (kp-k)*delta)*2*pi()/length(V); % (13)
    phi_delta = angle(V(k)) + ...
        (kp-k)*angle(exp(-j*delta*(pi()/length(V))*(length(V)-1))); % (19)
    Sk = zeros(3,1); % Suma pomocnicza (24)
    for n = 1:1:3
        for m = -M:1:M
            if (m == 0)
                Sk(n) = Sk(n) + (-1)^(m+n-2)*Am(1,M+1)/(delta-(m+n-2));
            else
                Sk(n) = Sk(n) + (-1)^(m+n-2)*Am(abs(m)+1,M+1)...
                    /2/(delta- (m+n-2));
            end
        end
    end
    if(M~=0)
        V_delta = 2*pi()/sin(delta*pi())*...
            (abs(V(kpp))+2*abs(V(k))+abs(V(kp)))...
            /(Sk(1)+2*Sk(2)+Sk(3)); % (23)
    end
end
end

