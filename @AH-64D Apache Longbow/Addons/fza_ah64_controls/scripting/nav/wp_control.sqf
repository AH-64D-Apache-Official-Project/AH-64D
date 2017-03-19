_su17 = _this select 0

fza_su17_steerpointstatus = 1
fza_su17_steerpointnext = 0
fza_su17_steerpointprev = 0

;;remove previous controls
_su17 removeaction fza_su17_steerpointadd
_su17 removeaction fza_su17_steerpointsav
_su17 removeaction fza_su17_steerpointclr
_su17 removeaction fza_su17_steerpointcls
_su17 removeaction fza_su17_steerpointnxt
_su17 removeaction fza_su17_steerpointprv

?(speed _su17 > 2 or speed _su17 < -2 or getpos _su17 select 2 > 5): goto "cyclepoints"

;;add steerpoint controls
fza_su17_steerpointadd = _su17 addAction ["Create Steerpoints","\fza_su17\scripting\steerpointadd.sqs"]
fza_su17_steerpointsav = _su17 addAction ["Save Steerpoints","\fza_su17\scripting\steerpointsave.sqs"]
fza_su17_steerpointclr = _su17 addAction ["Clear Steerpoints","\fza_su17\scripting\steerpointclear.sqs"]
#cyclepoints
fza_su17_steerpointcls = _su17 addAction ["Close Steerpoint Control","\fza_su17\scripting\steerpointclose.sqs"]
fza_su17_steerpointnxt = _su17 addAction ["Next Steerpoint","\fza_su17\scripting\steerpointnext.sqs"]
fza_su17_steerpointprv = _su17 addAction ["Previous Steerpoint","\fza_su17\scripting\steerpointprev.sqs"]

#waitloop
~1
?(fza_su17_steerpointstatus == 0): goto "end"
?!(alive _su17): goto "end"
goto "waitloop"

#end
_su17 removeaction fza_su17_steerpointadd
_su17 removeaction fza_su17_steerpointsav
_su17 removeaction fza_su17_steerpointclr
_su17 removeaction fza_su17_steerpointcls
_su17 removeaction fza_su17_steerpointnxt
_su17 removeaction fza_su17_steerpointprv
exit