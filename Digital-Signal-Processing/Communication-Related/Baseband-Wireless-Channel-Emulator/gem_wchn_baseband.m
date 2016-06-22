function [r] = gem_wchn_baseband(s, tao, p, fd, a, Ts, M)
%[r] = gem_wchn_baseband(s, tao, p, fd, a, Ts, M)
%  Description
%    A baseband model for wireless channel with fading and multipath
%  Return
%    r:  received signal
%  Parameters
%    NOTE: all vector parameters must be column vectors.
%    s:   transmitted signal
%    tao: delay of each path
%    p:   power assignment coeffecient of each path
%    fd:  Doppler spread of each path
%    a:   mean square root of noise
%    Ts:  sampling period
%    M:   number of scatterers

  % number of path
  N = length(tao);
  
  % number of signal samples
  L = length(s);

  % calculate noise
  % seed for noise random is hard coded
  n = gem_awgn(L, a, 0.371, 0.669);
  
  % calculate random parameters
  % seed for theta is hard coded
  alpha = zeros(L, M, N);   % M*N random variables totally, one for a scatterer of a path
  beta = zeros(L, M, N);    % M*N random variables totally, one for a scatterer of a path
  theta = zeros(L, N);      % N random variables totally, one for each path
  svt = gem_unirand(N, 0.4115);     % seed for theta is also random
  sva = gem_unirand(N*M, 0.1273);   % seed for alpha is also random
  svb = gem_unirand(N*M, 0.7429);   % seed for beta is also random
  for k = 1:N     % for each path
    st = svt(k);
    theta(:,k) = 2 * pi * gem_unirand(L, st);
    for m = 1:M   % for each scatterer
      sa = sva((k-1)*M+m);
      alpha(:,m,k) = 2 * pi * gem_unirand(L, sa);
      sb = svb((k-1)*M+m);
      beta(:,m,k) = 2 * pi * gem_unirand(L, sb);
    end
  end
  
  % calcute recieved signal
  r = zeros(L, 1);
  fI = zeros(N, 1);
  fQ = zeros(N, 1);
  for i = 1:L     % for each sample
    for k = 1:N     % for each path
      fI(k) = 0;
      fQ(k) = 0;
      for m = 1:M     % for each scatterer
        scat = cos(((2*m-1)*pi + theta(i)) / (4 * M));
        fI(k) = fI(k) + cos(2 * pi * fd(k) * scat * k * Ts + alpha(i,m,k));
        fQ(k) = fQ(k) + sin(2 * pi * fd(k) * scat * k * Ts + beta(i,m,k));
      end
    end
    fI = fI / sqrt(M);
    fQ = fQ / sqrt(M);
    f = fI + 1i * fQ;   % 1i is j, for performance improvement
    
    % calculate delayed path signal samples
    sd = zeros(N, 1);
    for k = 1:N
      if i-tao(k) < 1
        sd(k) = 0;    % transmitted signal is causal signal
      else
        sd(k) = s(i-tao(k));
      end
    end
    
    % sum up each signals from each path and noise
    r(i) = n(i) + sum(p.*f.*sd);
  end
  
end

