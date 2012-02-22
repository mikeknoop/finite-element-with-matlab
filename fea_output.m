function fea_output(utot,ptot)
%
% This function is used to output finite element results to the
% MATLAB window or, perhaps, to a file (not included here).

% establish variables for outputs to work with
% define global arrays
global ielem iprops eprops elname iforce force idisp disp
global Kff Kfe Kee Uf Ue Ff Fe
global x
global D
%
nnode = D.nnode;    % no. of nodes in model
nel = D.nel;        % no. of elements in model
nforce = D.nforce;  % no. of nodal forces in model
ndisp = D.ndisp;    % no. of essential displacements in model
etype = D.etype;    % element type (only one per model)
ndof = D.ndof;      % no. of dofs at each node
nenode = D.nenode;  % no. of nodes per element
elname = D.elname;  % name of element Mfile
%
% initialize equation numbers for dofs
ieqn = initialize(D);

%
% calculate stresses
stresses = zeros(nel, 1);
for i = 1:nel;
    % element stresses
    icode = 3;
    [eldat,ieleqn] = feval(elname,eprops(iprops(i),:),ielem(i,1:2),ieqn,D,icode);
    stresses(i) = eldat;
end

%
% plot 2D undeformed and deformed elements to screen
sf = 1e7; % factor to scale deformations by
xy = x;
xy(:,3) = []; % delete z data column
A = zeros(nnode,nnode)
for i = 1:nel;
    m = ielem(i,1);
    n = ielem(i,2);
    A(m,n) = 1;
end;
gplot3(A,xy) % plot undeformed
axis([min(xy(:,1))-2 max(xy(:,1))+2 min(xy(:,2))-2 max(xy(:,2))+2]) % zoom out
hold on;
% add on deformations
for i = 1:nnode;
    xy(i,1) = xy(i,1)+sf*(utot((2*i)-1));
    xy(i,2) = xy(i,2)+sf*(utot((2*i)));
end;
gplot3(A,xy,'red') % plot deformed
axis([min(xy(:,1))-2 max(xy(:,1))+2 min(xy(:,2))-2 max(xy(:,2))+2]) % zoom out
legend('undeformed', ['deformed (scaled ' num2str(sf,'%G') ')'])
hold off;

%
% print the following to the screen
utot
ptot
stresses