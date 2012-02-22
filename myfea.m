function myfea(filename)
%
% This is the main program that controls the execution of the various
% finite element computations. Global arrays are defined and sizes of
% arrays are set, as required. The is executed by typing:
%
% >> myfea('filename')
%
% at the MATLAB prompt where 'filename' refers to the input file named
% filename.txt in the current directory. This program calls all of the
% functions needed to run a finite element simulation. It also contains
% the calculations that invert the global reduced stiffness matrix and
% performs the back substitution step that computes the unknown nodal
% degrees-of-freedom. Reaction loads are then computed.
%
% define global arrays
global ielem iprops eprops elname iforce force idisp disp
global Kff Kfe Kee Uf Ue Ff Fe
global x
global utot ptot
global D
%
% assign input filename
filename = [filename '.txt']
%
% read input file
D = fea_input(filename)
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
% initialize global matrices;
Kff = zeros(nnode*ndof-ndisp);
Kfe = zeros(nnode*ndof-ndisp,ndisp);
Kee = zeros(ndisp,ndisp);
Uf = zeros(nnode*ndof-ndisp,1);
Ue = disp';
Ff = zeros(nnode*ndof-ndisp,1);
Fe = zeros(ndisp,1);
%
% compute and assemble element stiffness matrix
for i = 1:nel;
    % element stiffness matrix
    icode = 2;
    [eldat,ieleqn] = feval(elname,eprops(iprops(i),:),ielem(i,1:2),ieqn,D,icode);
    assemkp(eldat,ieleqn,D,icode);
    % element nodal load vector
    icode = 1;
    [eldat,ieleqn] = feval(elname,eprops(iprops(i),:),ielem(i,1:2),ieqn,D,icode);
    assemkp(eldat,ieleqn,D,icode);
end
%
% apply nodal forces
for i = 1:nforce;
    num = iforce(i,1)*ndof + iforce(i,2) - ndof;
    Ff(ieqn(num)) = Ff(ieqn(num)) + force(i);
end
%
% solve system of equations
Uf = Kff\(Ff - Kfe*Ue);
% compute nodal reactions
Fe = Kee*Ue + Kfe'*Uf;
%
% complete global displacement and force vector
%
for i = 1:D.nnode*D.ndof;
    if (ieqn(i) < 0);
        utot(i,1) = Ue(-ieqn(i));
        ptot(i,1) = Fe(-ieqn(i));
    else
        utot(i,1) = Uf(ieqn(i));
        ptot(i,1) = Ff(ieqn(i));
    end
end
fea_output(utot,ptot);