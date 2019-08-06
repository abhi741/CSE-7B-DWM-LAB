
CREATE TABLE Game_details (
                game_det_id VARCHAR(6) NOT NULL,
                players VARCHAR(20) NOT NULL,
                ram NUMERIC(6) NOT NULL,
                cost NUMERIC(10) NOT NULL,
                manufacture VARCHAR(20) NOT NULL,
                CONSTRAINT game_det_id PRIMARY KEY (game_det_id)
);


CREATE TABLE Spectator (
                spectator_id VARCHAR(6) NOT NULL,
                spec_name VARCHAR(20) NOT NULL,
                spec_type VARCHAR(20) NOT NULL,
                spec_age NUMERIC(3) NOT NULL,
                CONSTRAINT spectator_id PRIMARY KEY (spectator_id)
);


CREATE TABLE Game (
                game_id VARCHAR(6) NOT NULL,
                game_det_id VARCHAR(6) NOT NULL,
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


ALTER TABLE Game ADD CONSTRAINT Game_details_Game_fk
FOREIGN KEY (game_det_id)
REFERENCES Game_details (game_det_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Spectator_Video_Game_fact_fk
FOREIGN KEY (spectator_id)
REFERENCES Spectator (spectator_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Game_Video_Game_fact_fk
FOREIGN KEY (game_id)
REFERENCES Game (game_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Time_DT_Video_Game_fact_fk
FOREIGN KEY (time_id)
REFERENCES Time_DT (time_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Video_Game_fact ADD CONSTRAINT Location_Video_Game_fact_fk
FOREIGN KEY (location_id)
REFERENCES Location (location_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;