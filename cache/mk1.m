
%============================================================
% Materials
%============================================================
Components.uniaxialMaterial = containers.Map('KeyType', 'char', 'ValueType', 'any');
Components.geomTransf = containers.Map('KeyType', 'char', 'ValueType', 'any');
Components.uniaxialMaterial('None') = struct(...
    'E', Num<None>,...
    'eta', 0.0);
Components.uniaxialMaterial('None') = struct(...
    'E', Num<None>,...
    'eta', 0.0);
Components.uniaxialMaterial('None') = struct(...
    'E', Num<None>,...
    'eta', 0.0);
Components.uniaxialMaterial('None') = struct(...
    'E', Num<None>,...
    'eta', 0.0);
Components.uniaxialMaterial('None') = struct(...
    'E', Num<None>,...
    'eta', 0.0);
Components.geomTransf('2') = struct(...
    'name', 2,...
    'vecxz', [0, 0, 1],...
    'joint_offsets', [0.0, 0.0, 0.0; 0.0, -38.489307796673366, 0.0]);
Components.uniaxialMaterial('None') = struct(...
    'E', Num<None>,...
    'eta', 0.0);
Components.geomTransf('1') = struct(...
    'name', 1,...
    'vecxz', [0, 0, 1]);


%============================================================
% Elements
%============================================================
% Specify element types

ElemData = cell(8,1);
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

ElemType.bent_base.materials = [<ElasticUniaxialMaterial object at 0x7fb3a46af580>, <ElasticUniaxialMaterial object at 0x7fb3a46af700>, <ElasticUniaxialMaterial object at 0x7fb3a46af760>, <ElasticUniaxialMaterial object at 0x7fb3a46af7c0>, <ElasticUniaxialMaterial object at 0x7fb3a46af820>, <ElasticUniaxialMaterial object at 0x7fb3a46af880>];
ElemType.bent_base.dofs = ['dx', 'dy', 'dz', 'rx', 'ry', 'rz'];
ElemType.bent_base.do_rayleigh = 0;

ElemType.abutments.materials = [<ElasticUniaxialMaterial object at 0x7fb3a46af4c0>, <ElasticUniaxialMaterial object at 0x7fb3a46af460>, <ElasticUniaxialMaterial object at 0x7fb3a46af040>, <ElasticUniaxialMaterial object at 0x7fb3a46af400>, <ElasticUniaxialMaterial object at 0x7fb3a46af6a0>, <ElasticUniaxialMaterial object at 0x7fb3a46af5e0>];
ElemType.abutments.dofs = ['dx', 'dy', 'dz', 'rx', 'ry', 'rz'];
ElemType.abutments.do_rayleigh = 0;

for el=[1, 4], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = ElemType.girder; end;
for el=[2, 3], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = ElemType.column; end;
for el=[5, 6], ElemName{el}='ElasticBeamColumn3D'; ElemData{el} = ElemType.link; end;
for el=[], ElemName{el}='ZeroLength3D'; ElemData{el} = ElemType.bent_base; end;
for el=[7, 8], ElemName{el}='ZeroLength3D'; ElemData{el} = ElemType.abutments; end;

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
XYZ(8,:) = [  3180.0 326.48931      0.0];
XYZ(9,:) = [     0.0 326.48931      0.0];

% Connections
CON(1,:) = [       1        3];
CON(2,:) = [       5        4];
CON(3,:) = [       7        6];
CON(4,:) = [       3        2];
CON(5,:) = [       4        3];
CON(6,:) = [       6        3];
CON(7,:) = [       2        8];
CON(8,:) = [       1        9];

%============================================================
% Constraints
%============================================================
%                x    y    z    yz   zx   xy  
BOUN(  5,:) = [   1    1    1    1    1    1];
BOUN(  7,:) = [   1    1    1    1    1    1];
BOUN(  8,:) = [   1    1    1    1    1    1];
BOUN(  9,:) = [   1    1    1    1    1    1];


% Create model
Model = Create_Model(XYZ, CON, BOUN, ElemName);
