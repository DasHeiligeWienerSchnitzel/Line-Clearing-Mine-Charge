params ["_box","_helper"];

_minRopeLength = 50;
_maxRopeLength = 100;

_ropeLength = _box getVariable ["ropeLength",_minRopeLength];
_box setVariable ["ropeLength", _ropeLength, true];

_helperAction = _box addAction
[
	"<t color='#FF0000'>Toggle Helper</t>",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_arguments params ["_helper"]; 
		if (isObjectHidden _helper) then {		
			_helper hideObjectGlobal false;
			_helpers = _target getVariable ["helpers",[]];;
			{
				_x hideObjectGlobal false;
			}forEach _helpers;
		}else{
			_helper hideObjectGlobal true;
			_helpers = _target getVariable ["helpers",[]];;
			{
				_x hideObjectGlobal true;
			}forEach _helpers;
		};
	},
	[_helper],
	1.5,
	true,
	true,
	"",
	"true",
	5,
	false,
	"",
	""
];
_box setVariable ["helperAction",_helperAction,true];

_increaseDistanceAction = _box addAction
[
	format ["<t color='#FFAC1C'>Increase Distance (%1/100)</t>",_box getVariable ["ropeLength",50]],
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_arguments params ["_maxRopeLength"];
		_currentRopeLength = _target getVariable ["ropeLength",50];
		_newRopeLength = _currentRopeLength + 10;
		if (_newRopeLength > _maxRopeLength) then {
			_target setVariable ["ropeLength", _currentRopeLength, true];
		}else{
			_target setVariable ["ropeLength", _newRopeLength, true];
			_target setUserActionText [_target getVariable "increaseDistanceAction",format ["<t color='#FFAC1C'>Increase Distance (%1/100)</t>", _newRopeLength]];
			_target setUserActionText [_target getVariable "decreaseDistanceAction",format ["<t color='#FFAC1C'>Decrease Distance (%1/100)</t>", _newRopeLength]];
			
			_helpers = _target getVariable ["helpers",[]];;
			{
				deleteVehicle _x;
			}forEach _helpers;
			[_target] execVM "scripts\helpers.sqf";
		};
	},
	[_maxRopeLength],
	1.5,
	true,
	false,
	"",
	"true",
	5,
	false,
	"",
	""
];
_box setVariable ["increaseDistanceAction",_increaseDistanceAction,true];

_decreaseDistanceAction = _box addAction
[
	format ["<t color='#FFAC1C'>Decrease Distance (%1/100)</t>",_box getVariable ["ropeLength",50]],
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_arguments params ["_minRopeLength"];
		_currentRopeLength = _target getVariable ["ropeLength",50];
		_newRopeLength = _currentRopeLength - 10;
		if (_newRopeLength < _minRopeLength) then {
			_target setVariable ["ropeLength", _currentRopeLength, true];
		}else{
			_target setVariable ["ropeLength", _newRopeLength, true];
			_target setUserActionText [_target getVariable "increaseDistanceAction",format ["<t color='#FFAC1C'>Increase Distance (%1/100)</t>", _newRopeLength]];
			_target setUserActionText [_target getVariable "decreaseDistanceAction",format ["<t color='#FFAC1C'>Decrease Distance (%1/100)</t>", _newRopeLength]];
			
			_helpers = _target getVariable ["helpers",[]];;
			{
				deleteVehicle _x;
			}forEach _helpers;
			[_target] execVM "scripts\helpers.sqf";
		};
	},
	[_minRopeLength],
	1.5,
	true,
	false,
	"",
	"true",
	5,
	false,
	"",
	""
];
_box setVariable ["decreaseDistanceAction",_decreaseDistanceAction,true];

_box addAction
[
	"<t color='#FF0000' size='1.5'>ARM DEVICE</t>",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_arguments params ["_box","_helper"];
		_target setVariable ["DeviceArmed",true,true];
		_target removeAction (_target getVariable "helperAction");
		_target removeAction (_target getVariable "increaseDistanceAction");
		_target removeAction (_target getVariable "decreaseDistanceAction");
		_target removeAction _actionID;
		
		_box addAction
		[
			"<t color='#008000' size='1.5'>DISARM DEVICE</t>",
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				_arguments params ["_box","_helper"];
				_target removeAction _actionId;
				_target removeAction (_target getVariable "fireLineChargeAction");
				[_box,_helper] execVM "scripts\addActions.sqf";
			},
			[_box,_helper],
			1.5,
			true,
			false,
			"",
			"true",
			5,
			false,
			"",
			""
		];
		
		_fireLineChargeAction = _box addAction
		[
			"<t color='#FF0000' size='1.5'>FIRE LINE CHARGE</t>",
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				_arguments params ["_box","_helper"];
				removeAllActions _target;
				[_box,_helper] execVM "scripts\fireLineCharge.sqf";
			},
			[_box,_helper],
			1.5,
			true,
			true,
			"",
			"true",
			5,
			false,
			"",
			""
		];
		_box setVariable ["fireLineChargeAction",_fireLineChargeAction,true];
	},
	[_box,_helper],
	1.5,
	true,
	false,
	"",
	"true",
	5,
	false,
	"",
	""
];