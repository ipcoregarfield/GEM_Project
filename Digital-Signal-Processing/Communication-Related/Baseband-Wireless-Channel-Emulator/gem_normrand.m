function [n] = gem_normrand(sz, s1, s2)
%gem_normrand(sz, u0, v0)
%  Return
%    n:  a random vector following the standard normal distribution
%  Parameters
%    sz:     random vector size
%    s1, s2: two independent seeds which both ranges in (0,1)

%    NOTE: Refer to function gem_unirand() for parameters description.

  u = gem_unirand(sz, s1);
  v = gem_unirand(sz, s2);
  n = sqrt(-2*log(u)) .* cos(2*pi*v);
end

