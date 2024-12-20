BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nf_puppy_tricks_3nf CASCADE CONSTRAINTS';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nf_tricks_3nf CASCADE CONSTRAINTS';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nf_puppies_3nf CASCADE CONSTRAINTS';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nf_shelters_3nf CASCADE CONSTRAINTS';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
END;
/

CREATE TABLE nf_shelters_3nf (
  shelter_code NUMBER NOT NULL,
  shelter_name VARCHAR2(30) NOT NULL,
  shelter_location VARCHAR2(20) NOT NULL,

  CONSTRAINT nf_shelters_3nf_pk PRIMARY KEY (shelter_code)
);

CREATE TABLE nf_puppies_3nf (
  puppy_number NUMBER NOT NULL,
  puppy_name VARCHAR2(15) NOT NULL,
  shelter_code NUMBER NOT NULL,

  CONSTRAINT nf_puppies_3nf_pk PRIMARY KEY (puppy_number),
  CONSTRAINT nf_puppies_3nf_fk FOREIGN KEY (shelter_code)
    REFERENCES nf_shelters_3nf(shelter_code)
);

CREATE TABLE nf_tricks_3nf (
  trick_id NUMBER NOT NULL,
  trick_name VARCHAR2(25) NOT NULL,

  CONSTRAINT nf_tricks_3nf_pk PRIMARY KEY (trick_id)
);

CREATE TABLE nf_puppy_tricks_3nf (
  puppy_number NUMBER NOT NULL,
  trick_id NUMBER NOT NULL,
  skill_level NUMBER NOT NULL,

  CONSTRAINT nf_puppy_tricks_3nf_pk PRIMARY KEY (puppy_number, trick_id),
  CONSTRAINT nf_puppy_tricks_3nf_fk_puppy_number FOREIGN KEY (puppy_number)
    REFERENCES nf_puppies_3nf(puppy_number),
  CONSTRAINT nf_puppy_tricks_3nf_fk_trick_id FOREIGN KEY (trick_id)
    REFERENCES nf_tricks_3nf(trick_id),
  CONSTRAINT nf_puppy_tricks_3nf_skill_level_ck
    CHECK (skill_level >= 1 AND skill_level <= 5)
);

INSERT INTO nf_shelters_3nf
  (shelter_code, shelter_name, shelter_location)
  VALUES (5, 'Sacramento SPCA', 'Florin');
INSERT INTO nf_shelters_3nf
  (shelter_code, shelter_name, shelter_location)
  VALUES (6, 'Homeward Bound', 'Elverta');

INSERT INTO nf_puppies_3nf
  (puppy_number, puppy_name, shelter_code)
  VALUES (52, 'Luna', 5);
INSERT INTO nf_puppies_3nf
  (puppy_number, puppy_name, shelter_code)
  VALUES (53, 'Bear', 5);
INSERT INTO nf_puppies_3nf
  (puppy_number, puppy_name, shelter_code)
  VALUES (54, 'Milo', 5);
INSERT INTO nf_puppies_3nf
  (puppy_number, puppy_name, shelter_code)
  VALUES (55, 'Bella', 6);
INSERT INTO nf_puppies_3nf
  (puppy_number, puppy_name, shelter_code)
  VALUES (56, 'Max', 6);
INSERT INTO nf_puppies_3nf
  (puppy_number, puppy_name, shelter_code)
  VALUES (57, 'Bailey', 6);

INSERT INTO nf_tricks_3nf
  (trick_id, trick_name)
  VALUES (12, 'Sit');
INSERT INTO nf_tricks_3nf
  (trick_id, trick_name)
  VALUES (16, 'Speak');
INSERT INTO nf_tricks_3nf
  (trick_id, trick_name)
  VALUES (27, 'Roll Over');
INSERT INTO nf_tricks_3nf
  (trick_id, trick_name)
  VALUES (30, 'Shake Paws');

INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (52, 27, 5);
INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (53, 12, 3);
INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (53, 30, 4);
INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (54, 27, 4);
INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (55, 27, 2);
INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (55, 30, 5);
INSERT INTO nf_puppy_tricks_3nf
  (puppy_number, trick_id, skill_level)
  VALUES (57, 16, 5);
