params ["_box","_helper"];

deleteVehicle _helper;
private _helpers = _box getVariable ["helpers",[]];
{
    deleteVehicle _x;
} forEach _helpers;

_box enableSimulationGlobal false;

private _endPoint = "C_Quadbike_01_F" createVehicle (_box getRelPos [5,0]);
_endPoint setDir getDir _box;
_endPoint setObjectTextureGlobal [0,""];
_endPoint setObjectTextureGlobal [1,""];
_endPoint allowDamage false;

private _distance = _box getVariable ["ropeLength",50];

private _rope = ropeCreate [
    _endPoint,
    [0,0,-1.5],   // slight downward offset at endpoint
    _box,
    [0,0,-0.1],   // slight downward offset at box
    _distance
];

_endPoint setVelocityModelSpace [0, _distance / 4, 0.5 * 9.81 * 4];

sleep 3;

private _timeout = time + 8;   // fallback after 8 seconds

waitUntil {
    sleep 0.02;

    private _landed =
        (getPosATL _endPoint select 2) < 0.08
        && {abs (velocity _endPoint select 2) < 0.3}
        && {speed _endPoint < 0.3};

    private _timedOut = time > _timeout;

    _landed || _timedOut
};
_endPoint setVelocity [0,0,0];
_endPoint enableSimulationGlobal false;
_endPoint hideObjectGlobal true;
_endPoint setPosATL ((getPosATL _endPoint) vectorAdd [0,0,-0.15]);

// let rope visually settle
sleep 0.3;

private _ropeSegments = ropeSegments _rope;
private _savedPositions = [];

{
    if (_forEachIndex % 5 == 0) then {
        private _p = getPosATL _x;
        _p set [2, 0];   // force segment position to terrain
        _savedPositions pushBack _p;
    };
} forEach _ropeSegments;

private _detonationTime = time + 30;

while {time < _detonationTime} do {
    private _timeLeft = _detonationTime - time;

    playSound3D ["a3\3den\data\sound\cfgsound\notificationwarning.wss", _box, false, getPosASL _box, 5];

    private _sleepTime = switch true do {
        case (_timeLeft > 20): {3};
        case (_timeLeft > 10): {2};
        case (_timeLeft > 5):  {1};
        case (_timeLeft > 2):  {0.5};
        default                {0.25};
    };

    sleep _sleepTime;
};

deleteVehicle _endPoint;
deleteVehicle _box;
ropeDestroy _rope;

{
    "M_Mo_82mm_AT_LG" createVehicle _x;
} forEach _savedPositions;