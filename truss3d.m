function [eldat,ieleqn] = truss2d(eprop,lnodes,ieqn,D,icode)
%
% This function computes the element load vector (case 1) and
% element stiffness matrix (case 2) for a 2-D truss element. Note
% that the element load vector is zero. It starts by forming the
% element equation numbers that are required to assemble the global
% matrices.
%
global x            % access to global xyz coordinates
global disp         % access to global displacement arrays
global utot ptot    % access to post-processed load and displacement arrays
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
% need to get global (x1, y1, z1), (x2, y2, z2)  coordinates for this el
x1 = x(lnodes(1), 1);
y1 = x(lnodes(1), 2);
z1 = x(lnodes(1), 3);
x2 = x(lnodes(2), 1);
y2 = x(lnodes(2), 2);
z2 = x(lnodes(2), 3);
L = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2); % el length
l = (x2-x1)/L;
m = (y2-y1)/L;
n = (z2-z1)/L;
te = [l m n 0 0 0; 0 00 l m n];
%
% evaluate element matrices
switch icode
case 1
    % compute element load vector (if the element has some internal load)
    eldat = [0;0;0;0;0;0;];
case 2
    % compute element stiffness matrix
    % 2d truss has 2dof, so eldat should be a 4x4
    ke = ((eprop(1)*eprop(2))/L)*[1 -1;-1 1]; % AE/L
    eldat = (te')*ke*(te);
case 3
    % compute element stresses
    ux1 = utot((2*lnodes(1))-1);
    uy1 = utot((2*lnodes(1)));
    uz1 = utot((2*lnodes(1))+1);
    ux2 = utot((2*lnodes(2))-1);
    uy2 = utot((2*lnodes(2)));
    uz2 = utot((2*lnodes(2))+1);
    de = [ux1 uy1 uz1 ux2 uy2 uz2]';
    eldat = (eprop(2)/L)*[-l -m -n l m n]*de;
end