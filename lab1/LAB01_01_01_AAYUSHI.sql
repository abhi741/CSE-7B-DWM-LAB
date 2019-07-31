/*
AUTHOR : AAYUSHI SHAMKA
*/
CREATE TABLE GAME (
                GAMEID VARCHAR2(5) NOT NULL,
                TYPE VARCHAR2(15) NOT NULL,
                REQ VARCHAR2(3) NOT NULL,
                NAME VARCHAR2(10) NOT NULL,
                AGE VARCHAR2(5) NOT NULL,
                CONSTRAINT GAME_PK PRIMARY KEY (GAMEID)
);


CREATE TABLE SPEC (
                SPECID VARCHAR2(6) NOT NULL,
                SPEC VARCHAR2(16) NOT NULL,
                TYPE VARCHAR2(15) NOT NULL,
                NUM VARCHAR2(10) NOT NULL,
                ADD1 VARCHAR2(36) NOT NULL,
                CONSTRAINT SPEC_PK PRIMARY KEY (SPECID)
);


CREATE TABLE LOC (
                LOC_ID VARCHAR2(4) NOT NULL,
                CITY VARCHAR2(15) NOT NULL,
                STATE VARCHAR2(16) NOT NULL,
                COUN VARCHAR2(21) NOT NULL,
                SYTREET VARCHAR2(20) NOT NULL,
                CONSTRAINT LOC_PK PRIMARY KEY (LOC_ID)
);


CREATE TABLE TIME_ID (
                TIME_ID VARCHAR2(4) NOT NULL,
                DATE1 VARCHAR2(10) NOT NULL,
                MON VARCHAR2(4) NOT NULL,
                QUARTER VARCHAR2(4) NOT NULL,
                YEAR VARCHAR2(4) NOT NULL,
                CONSTRAINT TIMEID PRIMARY KEY (TIME_ID)
);


CREATE TABLE FACTTABLE (
                PRIKEY VARCHAR2(5) NOT NULL,
                CHARGES VARCHAR2(4) NOT NULL,
                CNT VARCHAR2(4) NOT NULL,
                TIME_ID VARCHAR2(4) NOT NULL,
                LOC_ID VARCHAR2(4) NOT NULL,
                SPEC_ID VARCHAR2(6) NOT NULL,
                GAME_ID VARCHAR2(5) NOT NULL,
                CONSTRAINT FT_PK PRIMARY KEY (PRIKEY)
);


ALTER TABLE FACTTABLE ADD CONSTRAINT GAME_FACTTABLE_FK
FOREIGN KEY (GAME_ID)
REFERENCES GINAME (GAMEID)
NOT DEFERRABLE;

ALTER TABLE FACTTABLE ADD CONSTRAINT SPEC_FACTTABLE_FK
FOREIGN KEY (SPEC_ID)
REFERENCES SPEC (SPECID)
NOT DEFERRABLE;

ALTER TABLE FACTTABLE ADD CONSTRAINT LOC_FACTTABLE_FK
FOREIGN KEY (LOC_ID)
REFERENCES LOC (LOC_ID)
NOT DEFERRABLE;

ALTER TABLE FACTTABLE ADD CONSTRAINT TIME_ID_FACTTABLE_FK
FOREIGN KEY (TIME_ID)
REFERENCES TIME_ID (TIME_ID)
NOT DEFERRABLE;


************************************************************************************

SQL> INSERT INTO TIME_ID VALUES('T101',01,01,01,2019);

1 row created.

SQL> INSERT INTO  TIME_ID VALUES ('T102',17,07,03,2017);

1 row created.

SQL> INSERT INTO GAME VALUES('G101','VR',02,'SUBWAY',18);

1 row created.

SQL> INSERT INTO GAME VALUES('G102','IWALL',03,'ROADRASH',18);

1 row created.

SQL> INSERT INTO LOC VALUES('L101','GONDIA','MH','IND','LANE1');

1 row created.

SQL> INSERT INTO LOC VALUES('L102','RAIPUR','CG','IND','LANE34');

1 row created.
SQL> INSERT INTO SPEC VALUES('S101','AAYUSHI','ADULT',9822343221,'PROFCOL');

1 row created.

SQL> INSERT INTO SPEC VALUES('S102','SANSKRUTI','CHILD',9822343221,'PROFCOLY');

1 row created.

SQL> INSERT INTO FACTTABLE VALUES('F101',200,20,'T101','L101','S101','G101');

1 row created.

SQL> INSERT INTO FACTTABLE VALUES('F102',220,10,'T102','L102','S102','G102');

1 row created.


SQL> SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME FROM USER_CONSTRAINTS
  2  WHERE UPPER(TABLE_NAME) IN ('TIME_ID','LOC','GAME','SPEC','FACTTABLE');

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
SYS_C0011604                   C TIME_ID
SYS_C0011603                   C TIME_ID
SYS_C0011602                   C TIME_ID
SYS_C0011601                   C TIME_ID
SYS_C0011600                   C TIME_ID
SYS_C0011598                   C SPEC
SYS_C0011597                   C SPEC
SYS_C0011596                   C SPEC
SYS_C0011595                   C SPEC
SYS_C0011594                   C SPEC
SYS_C0011592                   C FACTTABLE

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
SYS_C0011591                   C FACTTABLE
SYS_C0011590                   C FACTTABLE
SYS_C0011589                   C FACTTABLE
SYS_C0011588                   C FACTTABLE
SYS_C0011587                   C FACTTABLE
SYS_C0011586                   C FACTTABLE
SYS_C0011584                   C LOC
SYS_C0011583                   C LOC
SYS_C0011582                   C LOC
SYS_C0011581                   C LOC
SYS_C0011580                   C LOC

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
SYS_C0011578                   C GAME
SYS_C0011577                   C GAME
SYS_C0011576                   C GAME
SYS_C0011574                   C GAME
SYS_C0011575                   C GAME
TIME_ID_FACTTABLE_FK           R FACTTABLE
SPEC_FACTTABLE_FK              R FACTTABLE
LOC_FACTTABLE_FK               R FACTTABLE
GAME_FACTTABLE_FK              R FACTTABLE
GAME_PK                        P GAME
LOC_PK                         P LOC

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
FT_PK                          P FACTTABLE
SPEC_PK                        P SPEC
TIMEID                         P TIME_ID

36 rows selected.



SQL> INSERT INTO FACTTABLE VALUES('F103',55,8,'T665','L009','S434','G676');
INSERT INTO FACTTABLE VALUES('F103',55,8,'T665','L009','S434','G676')
*
ERROR at line 1:
ORA-02291: integrity constraint (AAYUSHI.TIME_ID_FACTTABLE_FK) violated -
parent key not found


**********************************************************************