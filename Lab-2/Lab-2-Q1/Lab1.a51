// -- DO NOT CHANGE ANYTHING UNTIL THE **** LINE--//
ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL ADD16
HERE: SJMP HERE
ORG 130H
// *****************
ADD16:
MOV A,71H
ADD A,73H
MOV 76H,A
MOV A,70H
ADDC A,72H
MOV 75H,A
MOV A,#0H
ADDC A,#0H
MOV 74H,A
RET
END