
%============================================================
% Materials
%============================================================
Components.geomTransf = containers.Map('KeyType', 'char', 'ValueType', 'any');
Components.geomTransf('1') = struct(...
    'name', 1,...
    'vecxz', [0, 0, 1]);
Components.geomTransf('2') = struct(...
    'name', 2,...
    'vecxz', [0, 0, 1],...
    'joint_offsets', [0.0, 0.0, 0.0; 0.0, -38.489307796673366, 0.0]);


%============================================================
% Elements
%============================================================
% Specify element types

ElemData = cell(6,1);
ElemType.girder.A = 12069.250000000002;
ElemType.girder.E = 4074280.688047892;
ElemType.girder.G = 1697616.9533532884;
ElemType.girder.J = 2000000000.0;
ElemType.girder.Iy = 508373515.28645855;
ElemType.girder.Iz = 9234610.567795722;
ElemType.girder.geom = Components.geomTransf('1');
ElemType.girder.mass_density = 2.6231165552390654;
ElemType.girder.cMass = true;

ElemType.column.A = 2827.4333882308147;
ElemType.column.E = 4074280.688047892;
ElemType.column.G = 1697616.9533532884;
ElemType.column.J = 2000000000.0;
ElemType.column.Iy = 636172.5123519334;
ElemType.column.Iz = 636172.5123519334;
ElemType.column.geom = Components.geomTransf('2');
ElemType.column.mass_density = 0.0;
ElemType.column.cMass = true;

ElemType.link.A = 12069.250000000002;
ElemType.link.E = 4074280.688047892;
ElemType.link.G = 1697616.9533532884;
ElemType.link.J = 2000000000.0;
ElemType.link.Iy = 508373515.28645855;
ElemType.link.Iz = 9234610.567795722;
ElemType.link.geom = Components.geomTransf('1');
ElemType.link.mass_density = 2.6231165552390654;
ElemType.link.cMass = true;

for el=[1, 4], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = ElemType.girder; end;
for el=[2, 3], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = ElemType.column; end;
for el=[5, 6], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = ElemType.link; end;

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
