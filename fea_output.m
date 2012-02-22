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

stresses = zeros(nel, 1)
%
% Calculate stresses
for i = 1:nel;
    % element stresses
    icode = 3;
    [eldat,ieleqn] = feval(elname,eprops(iprops(i),:),ielem(i,1:2),ieqn,D,icode);
    stresses(i) = eldat
end

%
% print the following to the screen
utot
ptot
stresses