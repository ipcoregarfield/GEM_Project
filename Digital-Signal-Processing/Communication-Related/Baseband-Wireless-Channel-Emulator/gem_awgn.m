function [n] = gem_awgn(sz, a, s1, s2)
%[n] = gem_awgn(sz, a, s1, s2)
%  Return
%    n:  a vector of additive white gaussian noise.
%  Parameters
%    sz:  size of noise vector
%    a:   mean square root of noise
%    s1, s2: two independent seeds which both ranges in (0,1)

  n = a * gem_normrand(sz, s1, s2);
  
end

