function [u] = gem_unirand(sz, seed)
%[u] = gem_unirand(sz, u0)
%  Return
%    u:  a random vector distributed uniformly on (0, 1)
%  Parameters
%    sz:   random vector size
%    seed: seed which ranges in (0,1)

%  Note
%    Given initial random value u0, the random variables are deduced by:
%        u(i+1)=(g * u(i)) mod n
%    where n is a primer in format (2^k)+1,
%          g is minimum primitive root modulo n,
%          and u(0) and g are relatively prime.

  % check seed
  if (seed <= 0.0) || (seed >= 1.0)
    error('Seed must be in range (0.0, 1.0).');
  end

    % algorithm parameters
    n = 65537;
    g = 75;
  
    % set first element
    u = zeros(sz, 1);   % preallocate space to improve performance
    u(1) = floor(n * seed);
    if u(1) <= 1
      u(1) = 2;
    end
    
    % deduce u(i) by u(i-1)
    for i = 2:sz
        u(i) = mod(g * u(i-1), n);
    end
    
    % normalize to (0,1)
    u = u / n;
end


