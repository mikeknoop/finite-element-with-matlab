function fea_output(utot,ptot)
%
% This function is used to output finite element results to the
% MATLAB window or, perhaps, to a file (not included here).

% establish variables for outputs to work with
% define global arrays
global ielem iprops eprops elname iforce force idisp disp
global x
global D ieqn
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
% calculate stresses
stresses = zeros(nel, 1);
for i = 1:nel;
    % element stresses
    icode = 3;
    [eldat,ieleqn] = feval(elname,eprops(iprops(i),:),ielem(i,1:2),ieqn,D,icode);
    stresses(i) = eldat;
end

%
% plot 2D or 3D undeformed and deformed truss elements to screen
xy = x;
A = zeros(nnode,nnode);
for i = 1:nel;
    m = ielem(i,1);
    n = ielem(i,2);
    A(m,n) = 1;
end;
gplot3(A,xy) % plot undeformed
axis([min(xy(:,1))-2 max(xy(:,1))+2 min(xy(:,2))-2 max(xy(:,2))+2]) % zoom out
hold on;
% add on deformations
mx = max(max(xy));
mxd = mx+max(max((utot)));
sf = round((1/abs(mx-mxd))/15); % factor to scale deformations by
for i = 1:nnode;
    xy(i,1) = xy(i,1)+sf*(utot((2*i)-1));
    xy(i,2) = xy(i,2)+sf*(utot((2*i)));
end;
gplot3(A,xy,'red--') % plot deformed
axis([min(xy(:,1))-2 max(xy(:,1))+2 min(xy(:,2))-3 max(xy(:,2))+3]) % zoom out
legend('undeformed', ['deformed (scaled ' num2str(sf,'%G') 'x)'])
hold off;

%
% print the following to the screen
utot
ptot
stresses