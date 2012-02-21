function ieqn = initialize(D)
global idisp
%
% This function is used to count the number of equations in the model and
% assign element equation numbers. Equation numbers increase from zero for
% free dofs and decrease from zero for prescribed dofs.
%
nnode = D.nnode;    % no. of nodes in model
ndof = D.ndof;      % no. of dofs per node
%
%set total degrees of freedom
ndoftot = D.nnode*D.ndof;
%
% initialize ieqn
ieqn = zeros(1,ndoftot);
%
% identify fixed degrees of freedom
iessential = 0;
for i = 1:D.ndisp;
    iessential = iessential + 1;
    num = idisp(i,1)*D.ndof + idisp(i,2) - D.ndof;
    ieqn(num) = -iessential;
end
%
% identify free degrees of freedom
ifree = 0;
for i = 1:ndoftot;
    if ieqn(i) == 0;
        ifree = ifree + 1;
        ieqn(i) = ifree;
    end
end
