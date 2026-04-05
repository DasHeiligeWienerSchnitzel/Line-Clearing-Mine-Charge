params ["_spawner"];

_spawnPosition = _spawner getRelPos [5, 0];

_box = "Box_NATO_AmmoOrd_F" createVehicle _spawnPosition;
clearItemCargoGlobal _box;
clearMagazineCargoGlobal _box;
_helper = "Sign_Arrow_Direction_F" createVehicle _spawnPosition;

_helper attachTo [_box, [0.03,0,0.32]];
_helper setObjectScale 0.5;

[_box,_helper] execVM "scripts\addActions.sqf";
[_box,_helper] execVM "scripts\helpers.sqf";