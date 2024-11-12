-- Anonymous PL/SQL script to drop any existing tables
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_subjects';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_subjects_ids';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_people';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_locations';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_segments';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_sources';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_episodes';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_careers';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_decades';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_monument_type';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_monuments';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mm_seasons';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
END;
/

-- Create tables that are referenced by other tables first
CREATE TABLE mm_seasons (
  season_id NUMBER PRIMARY KEY,
  season_number NUMBER NOT NULL UNIQUE
);

CREATE TABLE mm_monuments (
  monument_id NUMBER PRIMARY KEY,
  name VARCHAR2(30) NOT NULL UNIQUE
);

CREATE TABLE mm_monument_type (
  type_id NUMBER PRIMARY KEY,
  name VARCHAR2(30) NOT NULL UNIQUE
);

CREATE TABLE mm_decades (
  decade_id NUMBER PRIMARY KEY,
  name VARCHAR2(5) NOT NULL UNIQUE
);

CREATE TABLE mm_careers (
  career_id NUMBER PRIMARY KEY,
  name VARCHAR2(50) NOT NULL UNIQUE
);

-- Create tables that have foreign keys
CREATE TABLE mm_episodes (
  episode_id NUMBER PRIMARY KEY,
  episode_number NUMBER NOT NULL CHECK (episode_number > 0),
  episode_title VARCHAR2(75) NOT NULL,
  season_id NUMBER REFERENCES mm_seasons(season_id)
);

CREATE TABLE mm_sources (
  source_id NUMBER PRIMARY KEY,
  name VARCHAR2(50) NOT NULL,
  career NUMBER REFERENCES mm_careers(career_id)
);

CREATE TABLE mm_segments (
  segment_id NUMBER PRIMARY KEY,
  segment_number NUMBER(1) NOT NULL
    CHECK (segment_number >= 1 AND segment_number <= 6),
  episode_id NUMBER REFERENCES mm_episodes(episode_id),
  wikipedia_desc VARCHAR2(300) NOT NULL,
  monument NUMBER REFERENCES mm_monuments(monument_id),
  monument_type NUMBER REFERENCES mm_monument_type(type_id),
  decade NUMBER REFERENCES mm_decades(decade_id),
  source NUMBER REFERENCES mm_sources(source_id)
);

CREATE TABLE mm_locations (
  location_id NUMBER PRIMARY KEY,
  name VARCHAR2(100) NOT NULL,
  is_secondary_location CHAR(1) NOT NULL
    CHECK (is_secondary_location = 'Y' OR is_secondary_location = 'N'),
  segment_id NUMBER REFERENCES mm_segments(segment_id)
);

CREATE TABLE mm_people (
  person_id NUMBER PRIMARY KEY,
  name VARCHAR2(50) NOT NULL,
  segment_id NUMBER REFERENCES mm_segments(segment_id)
);

CREATE TABLE mm_subjects_ids (
  subject_id NUMBER PRIMARY KEY,
  name VARCHAR2(30) NOT NULL
);

CREATE TABLE mm_subjects (
  segment_id NUMBER REFERENCES mm_segments(segment_id),
  subject_id NUMBER REFERENCES mm_subjects_ids(subject_id),
  PRIMARY KEY (segment_id, subject_id)
);

-- Insert the values into the database
INSERT INTO mm_seasons (season_id, season_number) VALUES (1, 3);

INSERT INTO mm_monuments (monument_id, name) VALUES (1, 'Stone of Destiny');
INSERT INTO mm_monuments (monument_id, name) VALUES (2, 'Bust of Thomas Edison');
INSERT INTO mm_monuments (monument_id, name) VALUES (3, 'Washington Monument');
INSERT INTO mm_monuments (monument_id, name) VALUES (4, 'Niagra Falls');
INSERT INTO mm_monuments (monument_id, name) VALUES (5, 'Bellevue Place Sanatorium');
INSERT INTO mm_monuments (monument_id, name) VALUES (6, 'Moon''s lake house');
INSERT INTO mm_monuments (monument_id, name) VALUES (7, 'East Side Gallery');
INSERT INTO mm_monuments (monument_id, name) VALUES (8, 'Hollywood Walk of Fame');
INSERT INTO mm_monuments (monument_id, name) VALUES (9, 'Hancock Point Beach');
INSERT INTO mm_monuments (monument_id, name) VALUES (10, 'Sigmund Freud Statue');
INSERT INTO mm_monuments (monument_id, name) VALUES (11, 'The Alamo');
INSERT INTO mm_monuments (monument_id, name) VALUES (12, 'Wall Street');

INSERT INTO mm_monument_type (type_id, name) VALUES (1, 'Historical Object');
INSERT INTO mm_monument_type (type_id, name) VALUES (2, 'Statue');
INSERT INTO mm_monument_type (type_id, name) VALUES (3, 'Obelisk');
INSERT INTO mm_monument_type (type_id, name) VALUES (4, 'Natural Wonder');
INSERT INTO mm_monument_type (type_id, name) VALUES (5, 'Building');
INSERT INTO mm_monument_type (type_id, name) VALUES (6, 'Plaque');
INSERT INTO mm_monument_type (type_id, name) VALUES (7, 'Historic Location');

INSERT INTO mm_decades (decade_id, name) VALUES (1, '1850s');
INSERT INTO mm_decades (decade_id, name) VALUES (2, '1870s');
INSERT INTO mm_decades (decade_id, name) VALUES (3, '1890s');
INSERT INTO mm_decades (decade_id, name) VALUES (4, '1900s');
INSERT INTO mm_decades (decade_id, name) VALUES (5, '1910s');
INSERT INTO mm_decades (decade_id, name) VALUES (6, '1920s');
INSERT INTO mm_decades (decade_id, name) VALUES (7, '1940s');
INSERT INTO mm_decades (decade_id, name) VALUES (8, '1950s');
INSERT INTO mm_decades (decade_id, name) VALUES (9, '1960s');
INSERT INTO mm_decades (decade_id, name) VALUES (10, '1970s');
INSERT INTO mm_decades (decade_id, name) VALUES (11, '1980s');

INSERT INTO mm_careers (career_id, name) VALUES (1, 'Tour Guide');
INSERT INTO mm_careers (career_id, name) VALUES (2, 'Historian');
INSERT INTO mm_careers (career_id, name) VALUES (3, 'Reporter');
INSERT INTO mm_careers (career_id, name) VALUES (4, 'Playwright');
INSERT INTO mm_careers (career_id, name) VALUES (5, 'Businessman');
INSERT INTO mm_careers (career_id, name) VALUES (6, 'Journalist');
INSERT INTO mm_careers (career_id, name) VALUES (7, 'Author');
INSERT INTO mm_careers (career_id, name) VALUES (8, 'Professor');

INSERT INTO mm_episodes (episode_id, episode_number, episode_title, season_id)
  VALUES (1, 1, 'Destiny Stone; Niagara Falls; Madness of Mary Todd', 1);
INSERT INTO mm_episodes (episode_id, episode_number, episode_title, season_id)
  VALUES (2, 2, 'Freedom Balloon; First Film Star; Freud''s Therapy Dog', 1);

INSERT INTO mm_sources (source_id, name, career)
  VALUES (1, 'Catherine Cartwright', 1);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (2, 'Ben Model', 2);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (3, 'Steven Komarow', 3);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (4, 'Ginger Strand', 2);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (5, 'Catherine Filloux', 4);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (6, 'Danny Jameson', 5);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (7, 'Stegani Jackenthal', 6);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (8, 'Kelly Brown', 7);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (9, 'Herb Adams', 2);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (10, 'Robert Tobin', 8);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (11, 'Andrew Carroll', 7);
INSERT INTO mm_sources (source_id, name, career)
  VALUES (12, 'Tim Weiner', 6);

INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    1,
    1,
    1,
    'Don visits the famous London church, Westminster Abbey that set the stage for an audacious heist when Scottish Nationalist Ian Hamilton stole the Stone of Destiny.',
    1,
    1,
    8,
    1
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    2,
    2,
    1,
    'Don examines the story behind the Thomas Edison bust in West Orange, New Jersey and who invented motion pictures, Edison or French inventor Louis Le Prince.',
    2,
    2,
    3,
    2
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    3,
    3,
    1,
    'Don learns the Washington Monument in Washington, D.C. became a site to a standoff on December 8, 1982 when nine tourists were held hostage by nuclear bomb activist, Norman Mayer, who parked a dynamite-packed truck nearby.',
    3,
    3,
    11,
    3
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    4,
    4,
    1,
    'Don discovers the natural wonder of Niagara Falls, Mother Nature threatened to shut down in 1965.',
    4,
    4,
    9,
    4
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    5,
    5,
    1,
    'Don investigates Bellevue Place in Batavia, Illinois, an insane asylum that once housed first lady Mary Todd Lincoln, who was wrongfully incarcerated, but was freed by lawyer Myra Bradwell.',
    5,
    5,
    2,
    5
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    6,
    6,
    1,
    'Don uncovers the history of potato chips when chef George Crum cooked up the first batch for Cornelius Vanderbilt at Moon''s Lake House in Saratoga Springs, New York in 1853.',
    6,
    5,
    1,
    6
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    7,
    1,
    2,
    'Don visits the East Side Gallery in Berlin, Germany, a reminder of the daring escape of two families from Poessneck, East Germany who risked a flight to freedom in a homemade hot air balloon in 1979.',
    7,
    1,
    10,
    7
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    8,
    2,
    2,
    'Don uncovers the story behind IMP founder Carl Laemmle''s star on the Hollywood Walk of Fame when he started the 1910 publicity stunt of actress Florence Lawrence''s "death" to lure her away from Biograph Studios.',
    8,
    6,
    5,
    8
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    9,
    3,
    2,
    'Don investigates Hancock Point near Bar Harbor, Maine, once the gateway to Nazi spy Erich Gimpel and defector William Colepaugh''s plan to destroy America''s atomic bomb on Manhattan Project sites during World War II.',
    9,
    7,
    7,
    9
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    10,
    4,
    2,
    'Don examines the statue of Austrian neurologist Sigmund Freud at Clark University in Worcester, Massachusetts, whose Chow Chow Jofi, helped him hypothesize the psychological benefits of K-9 companions.',
    10,
    2,
    6,
    10
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    11,
    5,
    2,
    'Don returns to The Alamo in San Antonio, Texas where in 1908, after ranch heiress Clara Driscoll plan to demolish the Long Barracks, school teacher Adina De Zavala holds her own standoff to preserve the fort''s history.',
    11,
    5,
    4,
    11
  );
INSERT INTO mm_segments
  (
    segment_id,
    segment_number,
    episode_id,
    wikipedia_desc,
    monument,
    monument_type,
    decade,
    source
  )
  VALUES (
    12,
    6,
    2,
    'Don explores Wall Street in Manhattan''s Financial District, once the scene of a political bombing by Italian Anarchist Mario Buda in 1920.',
    12,
    7,
    6,
    12
  );

INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (1, 'Westminster Abbey, London, England', 'N', 1);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (2, 'Arbroath Abbey, Arbroath, Scotland', 'Y', 1);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (3, 'Edinburgh Castle, Edinburgh, Scotland', 'Y', 1);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (4, 'West Orange, New Jersey', 'N', 2);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (5, 'Science Museum, London, England', 'Y', 2);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (6, 'Washington, D.C.', 'N', 3);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (7, 'Niagara Falls, New York', 'N', 4);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (8, 'Batavia, Illinois', 'N', 5);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (9, 'Saratoga Springs, New York', 'N', 6);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (10, 'Berlin, Germany', 'N', 7);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (11, 'Poessneck, Germany', 'Y', 7);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (12, 'Los Angeles, California', 'N', 8);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (13, 'Bar Harbor, Maine', 'N', 9);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (14, 'Clark University, Worcester, Massachusetts', 'N', 10);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (15, 'Vienna, Austria', 'Y', 10);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (16, 'San Antonio, Texas', 'N', 11);
INSERT INTO mm_locations (location_id, name, is_secondary_location, segment_id)
  VALUES (17, 'New York, New York', 'N', 11);

INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (1, 'Ian Hamilton', 1);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (2, 'Thomas Edison', 2);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (3, 'Lizzie Le Prince', 2);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (4, 'Louis Le Prince', 2);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (5, 'Norman Mayer', 3);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (6, 'Steven Komarow', 3);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (7, 'Mary Todd Lincoln', 5);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (8, 'Myra Bradwell', 5);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (9, 'George Crum', 6);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (10, 'Cornelius Vanderbilt', 6);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (11, 'Peter Strelzyk', 7);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (12, 'Gunter Wetzel', 7);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (13, 'Carl Laemmle', 8);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (14, 'Florence Lawrence', 8);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (15, 'Erich Gimpel', 9);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (16, 'William Colepaugh', 9);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (17, 'Sigmund Freud', 10);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (18, 'Adina De Zavala', 11);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (19, 'Clara Driscoll', 11);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (20, 'William J. Flynn', 12);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (21, 'Paul Avrich', 12);
INSERT INTO mm_people (person_id, name, segment_id)
  VALUES (22, 'Mario Buda', 12);

INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (1, 'Political Movements');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (2, 'Motion Picture Industry');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (3, 'Terrorism');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (4, 'Nuclear Weapons');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (5, 'Natural Wonders');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (6, 'Engineering Feats');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (7, 'Women''s Rights');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (8, 'Food and Cuisine');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (9, 'Black History');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (10, 'Cold War Era');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (11, 'Daring Escapes');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (12, 'Spies and Espionage');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (13, 'Pets and Animals');
INSERT INTO mm_subjects_ids (subject_id, name)
  VALUES (14, 'Historic Preservation');

INSERT INTO mm_subjects (segment_id, subject_id) VALUES (1, 1);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (2, 2);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (3, 1);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (3, 3);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (3, 4);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (4, 5);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (4, 6);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (5, 7);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (6, 8);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (6, 9);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (7, 10);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (7, 11);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (8, 2);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (9, 12);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (9, 4);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (10, 13);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (11, 14);
INSERT INTO mm_subjects (segment_id, subject_id) VALUES (12, 3);
