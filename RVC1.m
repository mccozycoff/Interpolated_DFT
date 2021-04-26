function [ W ] = RVC1( N, M )
%RVC1 - funkcja okna Rife'a - Vincenta o zadanej klasie M i szerokości N

% Sprawdzenie poprawności argumentów
if(N <=0 || N ~= round(N))
    error('Please provide positive, integer number of samples (N)');
end
 
if(M <0 || M~= round(M) || M >6)
    error('Please provide value of M from {0,1,...6} set');
end
  
Am = [1 0 0 0 0 0 0; 1 1 0 0 0 0 0; 1 4/3 1/3 0 0 0 0; 1 3/2 3/5 ...
    1/10 0 0 0; 1 8/5 4/5 8/35 1/35 0 0; 1 105/63 60/63 45/126 ... 
    5/63 1/126 0; 1 396/231 495/462 110/231 33/231 6/231 1/462]';    % [1]

W = zeros(N,1);
for m = 0:1:M
    W = W + (-1)^m*Am(m+1,M+1)*cos(2*pi()/N*m*[0:1:(N-1)]');
end

end

% [1] Duda, K. (2011). Fourierowskie metody estymacji widm pra̜żkowych. Wydawnictwa AGH.
