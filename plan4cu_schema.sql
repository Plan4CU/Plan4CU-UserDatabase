CREATE DATABASE IF NOT EXISTS registrar_data;
USE registrar_data;

DROP TABLE IF EXISTS EquivCourses, wasReviewed, Review, CulpaCourse,
    CulpaProf, Requires, Requirement, Joins, Waitlist, Course, Section,
    Professor, Student, MajorTrack, Minor, Major, School;


/* Create the tables */
CREATE TABLE School -- necessary to include?
(
    school_id   VARCHAR(4) PRIMARY KEY,
    school_name VARCHAR(255) NOT NULL
);

CREATE TABLE Major
(
    major_id   VARCHAR(4) PRIMARY KEY,
    major_name VARCHAR(255) NOT NULL,
    school_id  VARCHAR(4)   NOT NULL, -- CC, SEAS, SART, etc.
    FOREIGN KEY (school_id) REFERENCES School (school_id)
);

# CREATE TABLE Minor
# (
#     minor_id   VARCHAR(4) PRIMARY KEY, -- COMS, ECON, etc.
#     minor_name VARCHAR(255) NOT NULL,
#     school_id  VARCHAR(4)   NOT NULL,  -- CC, SEAS, SART, etc.
#     FOREIGN KEY (school_id) REFERENCES School (school_id)
# );

CREATE TABLE MajorTrack
(
    track_id   INT PRIMARY KEY,
    track_name VARCHAR(255), -- Applications, Artificial Intelligence, etc.
    major_id   VARCHAR(4),
    FOREIGN KEY (major_id) REFERENCES Major (major_id)
);

CREATE TABLE Student
(
    s_uni       VARCHAR(7)   NOT NULL PRIMARY KEY,
    first_name  VARCHAR(255) NOT NULL,
    last_name   VARCHAR(255) NOT NULL,
    grad_year   YEAR,
    total_creds INT,
    major_id    VARCHAR(4)   NOT NULL, -- COMS, PHED, MATH
    # minor_id    VARCHAR(4)   DEFAULT NULL,
    track_id    INT,
    FOREIGN KEY (major_id) REFERENCES Major (major_id),
    #FOREIGN KEY (minor_id) REFERENCES Minor (minor_id),
    FOREIGN KEY (track_id) REFERENCES MajorTrack (track_id)
);

CREATE TABLE Professor
(
    p_uni      VARCHAR(7)   NOT NULL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL
);

CREATE TABLE Section
(
    section_id   INT  NOT NULL PRIMARY KEY, -- call num
    section_num  INT  NOT NULL,             -- 001, 002, ...
    capacity     INT  NOT NULL,
    num_enrolled INT,
    day          VARCHAR(15),               -- MW, TuTh, etc.
    start_time   TIME NOT NULL,
    end_time     TIME NOT NULL
);

CREATE TABLE Course
(
    course_id   VARCHAR(10)  NOT NULL PRIMARY KEY, -- COMS4153W
    course_name VARCHAR(255) NOT NULL,
    call_num    INT          NOT NULL,
    p_uni       VARCHAR(7)   NOT NULL,
    credits     INT          NOT NULL,
    is_prereq   BOOLEAN      NOT NULL,
    has_prereq  BOOLEAN      NOT NULL,
    is_core     BOOLEAN      NOT NULL,
    semester    VARCHAR(2),                        -- FA, SP
    year        YEAR,
    FOREIGN KEY (p_uni) REFERENCES Professor (p_uni),
    FOREIGN KEY (call_num) REFERENCES Section (section_id)
);

CREATE TABLE Waitlist
(
    waitlist_id  INT PRIMARY KEY AUTO_INCREMENT, -- not sure how waitlists are identified in SSOL db
    section_id   INT,
    capacity     INT,
    num_enrolled INT,
    FOREIGN KEY (section_id) REFERENCES Section (section_id)
);

CREATE TABLE Joins
(
    join_id     INT PRIMARY KEY AUTO_INCREMENT,
    s_uni       VARCHAR(7) NOT NULL,
    waitlist_id INT        NOT NULL,
    join_status BOOLEAN,
    FOREIGN KEY (s_uni) REFERENCES Student (s_uni),
    FOREIGN KEY (waitlist_id) REFERENCES Waitlist (waitlist_id)
);

CREATE TABLE Requirement
(
    req_id          INT PRIMARY KEY,
    req_name        VARCHAR(255), -- Global Core, Science, etc.
    fulfill_status VARCHAR(2)    -- N0, IP, TR, etc. referencing degree audit on ssol
);

/* Many courses can possibly fulfill requirement */
CREATE TABLE Requires
(
    course_id VARCHAR(10) NOT NULL,
    req_id    INT,
    major_id  VARCHAR(4)  NOT NULL, -- if core
    track_id  INT,                  -- if specific to track
    # minor_id  VARCHAR(4)  DEFAUlT NULL,
    PRIMARY KEY (course_id, req_id),
    FOREIGN KEY (course_id) REFERENCES Course (course_id),
    FOREIGN KEY (req_id) REFERENCES Requirement (req_id),
    FOREIGN KEY (major_id) REFERENCES Major (major_id),
    # FOREIGN KEY (minor_id) REFERENCES Minor (minor_id),
    FOREIGN KEY (track_id) REFERENCES MajorTrack (track_id)
);

CREATE TABLE CulpaProf
(
    c_prof_id INT PRIMARY KEY,
    p_uni     VARCHAR(7) NOT NULL,
    rating    DECIMAL(3, 2),
    FOREIGN KEY (p_uni) REFERENCES Professor (p_uni)
);

CREATE TABLE CulpaCourse
(
    c_course_id INT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    course_id   VARCHAR(10)  NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Course (course_id)
);

CREATE TABLE Review
(
    review_id   INT           NOT NULL PRIMARY KEY,
    c_course_id INT           NOT NULL,
    post_date   DATE,
    review_text TEXT          NOT NULL,
    p_rating    DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (c_course_id) REFERENCES CulpaCourse (c_course_id)
);

CREATE TABLE wasReviewed
(
    review_id   INT NOT NULL,
    c_prof_id   INT NOT NULL,
    c_course_id INT NOT NULL,
    PRIMARY KEY (review_id, c_prof_id),
    FOREIGN KEY (c_prof_id) REFERENCES CulpaProf (c_prof_id),
    FOREIGN KEY (c_course_id) REFERENCES CulpaCourse (c_course_id)
);

CREATE TABLE EquivCourses
(
    equiv_id INT PRIMARY KEY AUTO_INCREMENT,
    course1  VARCHAR(10) NOT NULL,
    course2  VARCHAR(10) NOT NULL,
    FOREIGN KEY (course1) REFERENCES Course (course_id),
    FOREIGN KEY (course2) REFERENCES Course (course_id),
    UNIQUE (course1, course2)
);

INSERT INTO School (school_id, school_name) VALUES
('CC', 'College of Arts and Sciences'),
('SEAS', 'School of Engineering and Applied Science'),
('GS', 'Graduate School of Arts and Sciences');

INSERT INTO Major (major_id, major_name, school_id) VALUES
('COMS', 'Computer Science', 'SEAS'),
('MATH', 'Mathematics', 'CC'),
('ECON', 'Economics', 'GS'),
('PHYS', 'Physics', 'CC');

# INSERT INTO Minor (minor_id, minor_name, school_id) VALUES
# ('COMS', 'Computer Science', 'SEAS'),
# ('ECON', 'Economics', 'CC'),
# ('MATH', 'Mathematics', 'CC'),
# ('PHYS', 'Physics', 'CC');

INSERT INTO MajorTrack (track_id, track_name, major_id) VALUES
(1, 'Applications', 'COMS'),
(2, 'Artificial Intelligence', 'COMS'),
(3, 'Financial', 'ECON');

# INSERT INTO Student (s_uni, first_name, last_name, grad_year, total_creds, major_id, minor_id, track_id) VALUES
INSERT INTO Student (s_uni, first_name, last_name, grad_year, total_creds, major_id,track_id) VALUES
('jmd1234', 'John', 'Doe', 2025, 60, 'COMS', 1),
('jrs4567', 'Jane', 'Smith', 2024, 90, 'MATH', 3),
('abj4128', 'Alice', 'Johnson', 2026, 30, 'PHYS', NULL),
('bwb8035', 'Bob', 'Brown', 2025, 80, 'MATH', NULL);

INSERT INTO Professor (p_uni, first_name, last_name) VALUES
('dff9', 'Donald', 'Ferguson'),
('gd2572', 'George', 'Dragomir'),
('skg21', 'Sunil', 'Gulati'),
('er2741', 'Eric', 'Raymer'),
('bsb2151', 'Brian', 'Borowski'),
('psb15', 'Paul', 'Blaer');

INSERT INTO Section (section_id, section_num, capacity, num_enrolled, day, start_time, end_time) VALUES
(11941, 003, 250, 267, 'Fr', '10:10:00', '12:40:00'),
(11837, 005, 106, 93, 'MoWe', '14:40:00', '15:55:00'),
(12196, 001, 210, 119, 'TuTh', '08:40:00', '09:55:00'),
(13270, 002, 180, 172, 'MoWe', '16:10:00', '17:25:00'),
(11932, 001, 250, 213, 'MoWe', '16:10:00', '17:25:00'),
(12617, 001, 50, 37, 'TuTh', '14:40:00', '15:55:00');

INSERT INTO Course (course_id, course_name, call_num, p_uni, credits, is_prereq, has_prereq, is_core, semester, year) VALUES
('COMS4111W', 'Introduction to Databases', 11941, 'dff9', 3, FALSE, FALSE, FALSE, 'FA', 2024),
('MATH1101UN', 'Calculus I', 11837, 'gd2572', 3, TRUE, FALSE, TRUE, 'SP', 2023),
('ECON1105UN', 'Principles of Economics', 12196, 'skg21', 4, TRUE, FALSE, TRUE, 'FA', 2023),
('PHYS1201UN', 'General Physics I', 13270, 'er2741', 3, TRUE, FALSE, FALSE, 'SP', 2024),
('COMS3134W', 'Data Structures in Java', 11932, 'bsb2151', 3, TRUE, TRUE, TRUE, 'FA', 2024),
('COMS3137W', 'Honors Data Structures & Algorithms', 12617, 'psb15', 4, TRUE, TRUE, FALSE, 'FA', 2024);

INSERT INTO Waitlist (waitlist_id, section_id, capacity, num_enrolled) VALUES
(1, 11941, 250, 23),
(2, 11837, 100, 10),
(3, 12196, 210, 74),
(4, 13270, 180, 11),
(5, 11932, 250, 45),
(6, 12617, 50, 04);

INSERT INTO Joins (join_id, s_uni, waitlist_id, join_status) VALUES
(1, 'jmd1234', 1, TRUE),
(2, 'abj4128', 4, TRUE),
(3, 'bwb8035', 2, TRUE),
(4, 'abj4128', 1, TRUE),
(5, 'jrs4567', 6, TRUE),
(6, 'jrs4567', 5, TRUE);

/*TODO: fix Requirement relationships, move fulfill_status to new table? or delete */
INSERT INTO Requirement (req_id, req_name, fulfill_status) VALUES
(1, 'Global Core', 'IP'),
(2, 'Science', 'OK'),
(3, 'Humanities', 'SR'),
(4, 'Writing', 'OK');

# INSERT INTO Requires (course_id, req_id, major_id, track_id, minor_id) VALUES
INSERT INTO Requires (course_id, req_id, major_id, track_id) VALUES
('MATH1101UN', 2, 'MATH', NULL),
('ECON1105UN', 3, 'ECON', NULL);

INSERT INTO CulpaProf (c_prof_id, p_uni, rating) VALUES
(1, 'dff9', 4.80),
(2, 'gd2572', 3.63),
(3, 'skg21', 3.61),
(4, 'er2741', 4.00);

INSERT INTO CulpaCourse (c_course_id, course_name, course_id) VALUES
(1, 'Introduction to Databases', 'COMS4111W'),
(2, 'Calculus I', 'MATH1101UN'),
(3, 'Principles of Economics', 'ECON1105UN'),
(4, 'General Physics I', 'PHYS1201UN');

INSERT INTO Review (review_id, c_course_id, post_date, review_text, p_rating) VALUES
(1, 2, '2024-01-15', 'Engaging and practical course with excellent professor.', 4.7),
(2, 3, '2024-01-20', 'A challenging class, but rewarding with good support.', 4.1),
(3, 1, '2024-02-05', 'Clear instruction and applicable real-world examples.', 4.0),
(4, 4, '2024-02-10', 'Great class, labs could be improved.', 3.9);

INSERT INTO wasReviewed (review_id, c_prof_id, c_course_id) VALUES
(1, 2, 2),
(2, 3, 3),
(3, 1, 1),
(4, 4, 4);

INSERT INTO EquivCourses (course1, course2) VALUES
('COMS3134W', 'COMS3137W');