

%============================================================
% Elements
%============================================================
% Specify element types
Partials.girder.A = 12069.250000000002;
Partials.girder.E = 4074280.688047892;
Partials.girder.G = 1697616.9533532884;
Partials.girder.Iy = 508373515.28645855;
Partials.girder.Iz = 9234610.567795722;
Partials.girder.geom = 'Linear';
Partials.girder.mass_density = 2.6231165552390654;
Partials.girder.cMass = True;
for el=[1, 4], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = Partials.girder; end;

Partials.column.A = 2827.4333882308147;
Partials.column.E = 4074280.688047892;
Partials.column.G = 1697616.9533532884;
Partials.column.Iy = 636172.5123519334;
Partials.column.Iz = 636172.5123519334;
Partials.column.geom = 'Linear';
Partials.column.mass_density = 0.0;
Partials.column.cMass = True;
for el=[2, 3], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = Partials.column; end;

Partials.link.A = 12069.250000000002;
Partials.link.E = 4074280.688047892;
Partials.link.G = 1697616.9533532884;
Partials.link.Iy = 508373515.28645855;
Partials.link.Iz = 9234610.567795722;
Partials.link.geom = 'Linear';
Partials.link.mass_density = 2.6231165552390654;
Partials.link.cMass = True;
for el=[5, 6], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = Partials.link; end;



% Element properties

ElemData = cell(6,1);

%============================================================
% Assemblage
%============================================================
% Node Definitions
XYZ(1,:) = [     0.0 326.48931      0.0];
XYZ(2,:) = [  3180.0 326.48931      0.0];
XYZ(3,:) = [  1752.0 326.48931      0.0];
XYZ(4,:) = [1608.8244 326.48931 177.43944];
XYZ(5,:) = [1608.8244      0.0 177.43944];
XYZ(6,:) = [1895.1756 326.48931 -177.43944];
XYZ(7,:) = [1895.1756      0.0 -177.43944];

% Connections
CON(1,:) = [       1        3];
CON(2,:) = [       5        4];
CON(3,:) = [       7        6];
CON(4,:) = [       3        2];
CON(5,:) = [       4        3];
CON(6,:) = [       6        3];

%============================================================
% Constraints
%============================================================
%                x    y    z    yz   zx   xy  
BOUN(  1,:) = [   1    1    1    1    1    1];
BOUN(  2,:) = [   1    1    1    1    1    1];
BOUN(  5,:) = [   1    1    1    1    1    1];
BOUN(  7,:) = [   1    1    1    1    1    1];


% Create model
Model = Create_Model(XYZ, CON, BOUN, ElemName);
