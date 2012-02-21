function [eldat,ieleqn] = spring1d(eprop,lnodes,ieqn,D,icode)
%
% This function computes the element load vector (case 1) and
% element stiffness matrix (case 2) for a 1-D spring element. Note
% that the element load vector is zero. It starts by forming the
% element equation numbers that are required to assemble the global
% matrices.
%
nenode = D.nenode;  % no. of nodes per element
ndof = D.ndof;      % no. of dofs per node
%
% determine the element equation numbers
jj = 0;
for j1 = 1:nenode;
    for j2 = 1:ndof;
        jj = jj + 1;
        numj = lnodes(j1)*ndof + j2 - ndof;
        ieleqn(jj) = ieqn(numj);
    end
end
%
% evaluate element matrices
switch icode
case 1
    % compute element load vector
    eldat = [0;0];
case 2
    % compute element stiffness matrix
    eldat = eprop(1)*[1 -1;-1 1];
end