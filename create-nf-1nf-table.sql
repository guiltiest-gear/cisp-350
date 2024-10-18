-- Use an anonymous PL/SQL script to drop any existing tables first
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nf_tricks_1nf';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nf_puppies_1nf';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
END;
/

-- Create the tables
CREATE TABLE nf_puppies_1nf (
  puppy_number NUMBER NOT NULL,
  puppy_name VARCHAR2(15) NOT NULL,
  shelter_name VARCHAR2(30) NOT NULL,
  shelter_location VARCHAR2(20) NOT NULL,

  CONSTRAINT nf_puppies_1nf_pk PRIMARY KEY (puppy_number)
);

CREATE TABLE nf_tricks_1nf (
  puppy_number NUMBER NOT NULL,
  trick_id NUMBER NOT NULL,
  trick_name VARCHAR2(25) NOT NULL,
  skill_level NUMBER NOT NULL,

  CONSTRAINT nf_tricks_1nf_pk PRIMARY KEY (puppy_number, trick_id),
  CONSTRAINT nf_tricks_1nf_fk FOREIGN KEY (puppy_number) REFERENCES nf_puppies_1nf(puppy_number),
  CONSTRAINT nf_tricks_1nf_skill_level_ck CHECK (skill_level >= 1 AND skill_level <= 5)
);

-- Insert the puppies into the database first
INSERT INTO nf_puppies_1nf (puppy_number, puppy_name, shelter_name, shelter_location) VALUES (52, 'Luna', 'Sacramento SPCA', 'Florin');
INSERT INTO nf_puppies_1nf (puppy_number, puppy_name, shelter_name, shelter_location) VALUES (53, 'Bear', 'Sacramento SPCA', 'Florin');
INSERT INTO nf_puppies_1nf (puppy_number, puppy_name, shelter_name, shelter_location) VALUES (54, 'Milo', 'Sacramento SPCA', 'Florin');
INSERT INTO nf_puppies_1nf (puppy_number, puppy_name, shelter_name, shelter_location) VALUES (55, 'Bella', 'Homeward Bound', 'Elverta');
INSERT INTO nf_puppies_1nf (puppy_number, puppy_name, shelter_name, shelter_location) VALUES (56, 'Max', 'Homeward Bound', 'Elverta');
INSERT INTO nf_puppies_1nf (puppy_number, puppy_name, shelter_name, shelter_location) VALUES (57, 'Bailey', 'Homeward Bound', 'Elverta');

-- Now insert the tricks
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (52, 27, 'Roll Over', 5);
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (53, 12, 'Sit', 3);
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (53, 30, 'Shake Paws', 4);
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (54, 27, 'Roll Over', 4);
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (55, 27, 'Roll Over', 2);
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (55, 30, 'Shake Paws', 5);
INSERT INTO nf_tricks_1nf (puppy_number, trick_id, trick_name, skill_level) VALUES (57, 16, 'Speak', 5);
