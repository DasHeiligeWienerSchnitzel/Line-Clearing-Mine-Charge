params ["_box"];

_ropeLength = _box getVariable ["ropeLength",50];
_helpers = [];

for "_i" from 0 to _ropeLength step 10 do {
	_helperSphere = createVehicle ["Sign_sphere25cm_EP1",getPos _box,[],0,"CAN_COLLIDE"];
	_helperSphere attachTo [_box,[0,_i,0]];
	_helpers pushBack _helperSphere;
};

_box setVariable ["helpers",_helpers,true];
