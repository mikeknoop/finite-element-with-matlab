function assemkp(eldat,ieleqn,D,icode);
%
% This function assembles the global load vector (case 1) and
% global stiffness matrices (case 2) from the element data in
% eldat and ieleqn. Free and essential dofs are accounted for
% via the sign on m and n.
%
% define global arrays
global Kff Kfe Kee Ff
%
ndof = D.ndof;      % no. of dofs at each node
nenode = D.nenode;  % no. of nodes per element
%
neldoftot = ndof*nenode;    % total no. of dofs per element
%
% assembly global arrays
switch icode
case 1
% assemble load vector
for j = 1:neldoftot;
    m = ieleqn(j);
        if (m > 0);
            Ff(m) = Ff(m) + eldat(j,1);
        end
end
case 2
% assemble stiffness matrix
for j = 1:neldoftot;
    m = ieleqn(j);
    for k = 1:neldoftot;
        n = ieleqn(k);
        if (n > 0);
            if (m > 0);
                Kff(m,n) = Kff(m,n) + eldat(j,k);
            end
        else
            if (m > 0);      
                Kfe(m,-n) = Kfe(m,-n) + eldat(j,k);
            else
                Kee(-m,-n) = Kee(-m,-n) + eldat(j,k);
            end
        end
    end
end
end