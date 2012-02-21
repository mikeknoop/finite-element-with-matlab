function D = fea_input(filename)
%
% This function reads the input file filename.txt in the current directory.
% It starts by reading the number of nodes, elements, applied loads, 
% prescribed displacements and element type. It then reads nodal data,
% element data, load data, prescribed displacement data and finally, the
% element properties. The number of nodal dofs, nodes per element, and 
% number of element properties are also assigned for each element type.
%
%define global arrays
global ielem iprops eprops iforce force idisp disp
global x
%
% open input file
fid = fopen(filename,'r');
%
% read number of nodes, elements, applied forces and prescribed displacements, and element type
D.nnode = fscanf(fid,'%d',1);   % no. of nodes in model
D.nel = fscanf(fid,'%d',1);     % no. of elements in model
D.nforce = fscanf(fid,'%d',1);  % no. of applied forces in model
D.ndisp = fscanf(fid,'%d',1);   % no. of essential boundary conditions in model
D.etype = fscanf(fid,'%d',1);   % element type (only one per model)
%
% set properties related to element properties
switch D.etype
case 1
    % 2 node 1D spring element
    D.ndof = 1; D.nenode = 2; D.neprops = 1; D.elname = 'spring1d'; 
case 2
case 3
end
%
% read nodal data
x = zeros(D.nnode,3);
for j = 1:D.nnode;
    dummy = fscanf(fid,'%d',1);
    x(j,1:3) = fscanf(fid,'%g',3)';
end
%
% read element data
ielem = zeros(D.nel,D.nenode);
iprops = zeros(1,D.nel);
for j = 1:D.nel;
    fscanf(fid,'%d',1);
    iprops(j) = fscanf(fid,'%d',1);
    ielem(j,1:D.nenode) = fscanf(fid,'%d',D.nenode)';
end
%
% read applied loads
iforce = zeros(D.nforce,2);
force = zeros(1,D.nforce);
for j = 1:D.nforce;
    iforce(j,1:2) = fscanf(fid,'%d',2)';
    force(j) = fscanf(fid,'%g',1);
end
%
% read applied displacements
idisp = zeros(D.ndisp,2);
disp = zeros(1,D.ndisp);
for j = 1:D.ndisp
    idisp(j,1:2) = fscanf(fid,'%d',2)';
    disp(j) = fscanf(fid,'%g',1);
end
%
% read element properties
nprops = max(iprops);
eprops = zeros(nprops,D.neprops);
for j = 1:nprops;
    fscanf(fid,'%d',1);
    eprops(j,1:D.neprops) = fscanf(fid,'%g',D.neprops);
end
