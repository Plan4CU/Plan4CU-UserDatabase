CREATE DATABASE p1_database;
use p1_database;

create table if not exists course_sections
(
    course_id     bigint null,
    course_name   text   null,
    uuid          text   null,
    created_at    text   null,
    course_code   text   null,
    sis_course_id text   null,
    course_no     text   null,
    section       text   null,
    course_year   text   null,
    semester      text   null
);

insert into p1_database.course_sections
value (204283,
       "COMSW4153_001_2024_3 - Cloud Computing",
       "3jHCxUV0ck9Z8TF1sZeI8WTx47olDGkX1YPL3USM",
       "024-04-05T00:58:50Z",
       "COMSW4153_001_2024_3 - Cloud Computing",
       "COMSW4153_001_2024_3",
       "COMSW4153",
       "001",
       "2024",
       "3")

insert into p1_database.course_sections
value (204284,
       "Testing another class",
       "random field,
       "12369",
       "COMSW4153_001_2024_3 - Cheese creation",
       "valid_course_id",
       "course_number bro",
       "001",
       "2024",
       "3")

insert into p1_database.course_sections
value (204285,
       "Second testing class",
       "random fieldsss",
       "12369",
       "Basket Weaving",
       "course_numero_uno",
       "Course_number under achieving",
       "001",
       "2024",
       "3")

