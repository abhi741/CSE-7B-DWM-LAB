
CREATE TABLE Spectator (
                spectator_id VARCHAR(6) NOT NULL,
                spec_name VARCHAR(20) NOT NULL,
                spec_type VARCHAR(20) NOT NULL,
                spec_age NUMERIC(3) NOT NULL,
                CONSTRAINT spectator_id PRIMARY KEY (spectator_id)
);


CREATE TABLE Game (
                game_id VARCHAR(6) NOT NULL,
                game_name VARCHAR(20) NOT NULL,
                game_type VARCHAR(20) NOT NULL,
                game_descp VARCHAR(20) NOT NULL,
                CONSTRAINT game_id PRIMARY KEY (game_id)
);


CREATE TABLE Time_DT (
                time_id VARCHAR(6) NOT NULL,
                day NUMERIC(2) NOT NULL,
                month NUMERIC(2) NOT NULL,
                year NUMERIC(4) NOT NULL,
                CONSTRAINT time_id PRIMARY KEY (time_id)
);


CREATE TABLE Location (
                location_id VARCHAR(6) NOT NULL,
                street VARCHAR(6) NOT NULL,
                city VARCHAR(6) NOT NULL,
                state VARCHAR(6) NOT NULL,
                country VARCHAR(20) NOT NULL,
                CONSTRAINT location_id PRIMARY KEY (location_id)
);


CREATE TABLE Video_Game_fact (
                video_game_id VARCHAR(6) NOT NULL,
                time_id VARCHAR(6) NOT NULL,
                game_id VARCHAR(6) NOT NULL,
                location_id VARCHAR(6) NOT NULL,
                spectator_id VARCHAR(6) NOT NULL,
                count NUMERIC(5) NOT NULL,
                amount_sold VARCHAR(8) NOT NULL,
                CONSTRAINT video_game_id PRIMARY KEY (video_game_id)
);


ALTER TABLE Video_Game_fact ADD CONSTRAINT Spectator_Video_Game_fact_fk
FOREIGN KEY (spectator_id)
REFERENCES Spectator (spectator_id)
--ON DELETE NO ACTION
--ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Game_Video_Game_fact_fk
FOREIGN KEY (game_id)
REFERENCES Game (game_id)
--ON DELETE NO ACTION
--ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Time_DT_Video_Game_fact_fk
FOREIGN KEY (time_id)
REFERENCES Time_DT (time_id)
--ON DELETE NO ACTION
--ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Location_Video_Game_fact_fk
FOREIGN KEY (location_id)
REFERENCES Location (location_id)
--ON DELETE NO ACTION
--ON UPDATE NO ACTION
NOT DEFERRABLE;


-- oracle practical GAME MALL SCHEMA 


-- time schema
INSERT INTO  TIME_DT VALUES ('T101',04,11,2018);
INSERT INTO  TIME_DT VALUES ('T102',17,02,2017);
INSERT INTO  TIME_DT VALUES ('T103',15,12,2019);

SELECT * FROM TIME;
/*
TIME_I        DAY      MONTH       YEAR
------ ---------- ---------- ----------
T101            4         11       2018
T102           17          2       2017
T103           15         12       2019
*/

-- GAME SCHEMA
INSERT INTO GAME VALUES('G101','GN101','ARCADE','SINGLE');
INSERT INTO GAME VALUES('G102','GN102','ARCADE','MULTIPLE');
INSERT INTO GAME VALUES('G103','GN103','ACTION','SINGLE');
SELECT * FROM GAME;

/*
GAME_I GAME_NAME            GAME_TYPE            GAME_DESCP
------ -------------------- -------------------- --------------------
G101   GN101                ARCADE               SINGLE
G102   GN102                ARCADE               MULTIPLE
G103   GN103                ACTION               SINGLE
*/

-- location shecma

INSERT INTO LOCATION VALUES('L101','S101','C101','MH','INDIA');
INSERT INTO LOCATION VALUES('L102','S102','C101','MH','INDIA');
INSERT INTO LOCATION VALUES('L103','S103','C102','NY','USA');

SELECT * FROM LOCATION;

/*
LOCATI STREET CITY   STATE  COUNTRY
------ ------ ------ ------ --------------------
L101   S101   C101   MH     INDIA
L102   S102   C101   MH     INDIA
L103   S103   C102   NY     USA
*/


-- SPECTATOR

INSERT INTO SPECTATOR VALUES('SP10','AAY','STUDENT',19);
INSERT INTO SPECTATOR VALUES('SP11','POO','SENIOR CITIZEN',20);

SELECT * FROM SPECTATOR;
/*
SPECTA SPEC_NAME            SPEC_TYPE              SPEC_AGE
------ -------------------- -------------------- ----------
SP10   AAY                  STUDENT                      19
SP11   POO                  SENIOR CITIZEN               20
*/
-- FACT TABLE
INSERT INTO VIDEO_GAME_FACT VALUES('M101','T101','G101','L101','SP10',10,100);
INSERT INTO VIDEO_GAME_FACT VALUES('M102','T101','G102','L102','SP11',12,500);


SELECT * FROM VIDEO_GAME_FACT;

/*
VIDEO_ TIME_I GAME_I LOCATI SPECTA      COUNT AMOUNT_S
------ ------ ------ ------ ------ ---------- --------
M101   T101   G101   L101   SP10           10 100
M102   T101   G102   L102   SP11           12 500

*/

 SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME FROM USER_CONSTRAINTS 
		WHERE UPPER(TABLE_NAME) IN ('TIME_1','LOCATION','GAME_LOCATION','SPECTATOR','GAME','VIDEO_GAME_FACT');


/*
CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
SYS_C0014937                   C VIDEO_GAME_FACT
SYS_C0014936                   C VIDEO_GAME_FACT
SYS_C0014935                   C VIDEO_GAME_FACT
SYS_C0014934                   C VIDEO_GAME_FACT
SYS_C0014933                   C VIDEO_GAME_FACT
SYS_C0014932                   C VIDEO_GAME_FACT
SYS_C0014931                   C VIDEO_GAME_FACT
SYS_C0014929                   C LOCATION
SYS_C0014928                   C LOCATION
SYS_C0014927                   C LOCATION
SYS_C0014926                   C LOCATION

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
SYS_C0014925                   C LOCATION
SYS_C0014918                   C GAME
SYS_C0014915                   C GAME
SYS_C0014913                   C SPECTATOR
SYS_C0014912                   C SPECTATOR
SYS_C0014911                   C SPECTATOR
SYS_C0014917                   C GAME
SYS_C0014916                   C GAME
SYS_C0014910                   C SPECTATOR
LOCATION_VIDEO_GAME_FACT_FK    R VIDEO_GAME_FACT
TIME_DT_VIDEO_GAME_FACT_FK     R VIDEO_GAME_FACT

CONSTRAINT_NAME                C TABLE_NAME
------------------------------ - ------------------------------
GAME_VIDEO_GAME_FACT_FK        R VIDEO_GAME_FACT
SPECTATOR_VIDEO_GAME_FACT_FK   R VIDEO_GAME_FACT
SPECTATOR_ID                   P SPECTATOR
GAME_ID                        P GAME
LOCATION_ID                    P LOCATION
VIDEO_GAME_ID                  P VIDEO_GAME_FACT

28 rows selected.
*/


-- SHOWING ERROR FOR THE FOREGIN KEY WHICH DOES NOT EXISTS IN DIMMENSIONAL TABLE

INSERT INTO VIDEO_GAME_FACT VALUES('M103','T108','G102','L101','SP11',34,550);
/*
*
ERROR at line 1:
ORA-02291: integrity constraint (CHAMPION_DWM.TIME_DT_VIDEO_GAME_FACT_FK)
violated - parent key not found
*/
