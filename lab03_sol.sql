/* Create the database (dropping the previous version if necessary) */
DROP DATABASE IF EXISTS movie_ratings;

CREATE DATABASE movie_ratings;

/*Using our new movie_ratings database*/
USE movie_ratings;

/* Create the table with appropriate fields and assigned data types */
CREATE TABLE Movies (
    PRIMARY KEY (movie_id), /* Setting the Primary Key */
    movie_id                  INT AUTO_INCREMENT,
    movie_title               VARCHAR(250),
    movie_release_date        DATE, -- Date data type?
    movie_genre               VARCHAR(50) 
);

CREATE TABLE Consumers (
    PRIMARY KEY (consumer_id), /* Setting the Primary Key */
    consumer_id                    INT AUTO_INCREMENT,
    consumer_first_name            VARCHAR(64),
    consumer_last_name             VARCHAR(64),
    consumer_address               VARCHAR(150),
    consumer_city                  VARCHAR(15),
    consumer_state                 VARCHAR(2),
    consumer_zip_code              VARCHAR(6) -- is this the best data type?
);

CREATE TABLE Ratings (
    PRIMARY KEY (movie_id,consumer_id), /* Setting the Compound Primary Key */
    movie_id                  INT,
    consumer_id               INT,
    rating_when_rated         DATETIME, -- is there a data type to store data & time
    rating_star_number        INT
);

INSERT INTO Movies (movie_title,movie_release_date,movie_genre)
VALUES ("The Hunt for Red October",'1990-03-02', "Acton, Adventure, Thriller"),
       ("Lady Bird",'2017-12-01',	"Comedy, Drama"),
       ("Inception",'2010-08-16',"Acton, Adventure, Science Fiction"),
       ("Monty Python and the Holy Grail",'1975-04-03',"Comedy");

INSERT INTO Consumers (consumer_first_name,consumer_last_name,consumer_address,consumer_city,consumer_state,consumer_zip_code)
VALUES ("Toru","Okada","800 Glenridge Ave","Hobart","IN","46343"),
       ("Kumiko","Okada","864 NW Bohemia St","Vincentown","NJ","08088"),
       ("Noboru","Wataya","342 Joy Ridge St","Hermitage","TN","37076"),
       ("May","Kasahara","5 Kent Rd","East Haven","CT","06512");

INSERT INTO Ratings (movie_id,consumer_id,rating_when_rated,rating_star_number)
VALUES (1,1,'2010-09-02 10:54:19',4),
       (1,3,'2012-08-05 15:00:01',3),
       (1,4,'2016-10-02 23:58:12',1),
       (2,3,'2017-03-27 00:12:48',2),
       (2,4,'2018-08-02 00:54:42',4);

SHOW CREATE TABLE Movies;
SHOW CREATE TABLE Consumers;

SELECT * FROM Consumers; /*View all consumer data*/
SELECT * FROM Movies; /*View all Movie data*/

/*Join Ratings, Consumers and Movies to see the rating list*/
SELECT consumer_first_name, consumer_last_name, movie_title, rating_star_number
      FROM Movies
          NATURAL JOIN Ratings
          NATURAL JOIN Consumers;

-- FLAW IN THE DATABASE DESIGN
/*
According to me, the biggest flaw in this design is the Movie Genre field in the Movies table.
It is a multi-value field, and thus it should have a seperate table with the genres listed,
and then a linking table is needed since this is a many-to-many relationship.
*/

DROP DATABASE IF EXISTS movie_ratings;
CREATE DATABASE movie_ratings;
USE movie_ratings;

/*Initializing Tables needed and their fields*/
CREATE TABLE Movies (
    PRIMARY KEY (movie_id), /* Setting the Primary Key */
    movie_id                  INT AUTO_INCREMENT,
    movie_title               VARCHAR(250),
    movie_release_date        DATE
);

CREATE TABLE Genres (
    PRIMARY KEY (genre_id), /* Setting the Primary Key */
    genre_id                  INT AUTO_INCREMENT,
    genre_name               VARCHAR(25)
);

CREATE TABLE Movie_Genres (
    PRIMARY KEY (movie_id,genre_id),
    movie_id        INT,
    genre_id        INT
);

CREATE TABLE Consumers (
    PRIMARY KEY (consumer_id), /* Setting the Primary Key */
    consumer_id                    INT AUTO_INCREMENT,
    consumer_first_name            VARCHAR(64),
    consumer_last_name             VARCHAR(64),
    consumer_address               VARCHAR(150),
    consumer_city                  VARCHAR(15),
    consumer_state                 VARCHAR(2),
    consumer_zip_code              VARCHAR(6) -- is this the best data type?
);

CREATE TABLE Ratings (
    PRIMARY KEY (movie_id,consumer_id), /* Setting the Compound Primary Key */
    movie_id                  INT,
    consumer_id               INT,
    rating_when_rated         DATETIME, -- is there a data type to store data & time
    rating_star_number        INT
);

/*Adding data into Movies table*/
INSERT INTO Movies (movie_title,movie_release_date)
VALUES ("The Hunt for Red October",'1990-03-02'),
       ("Lady Bird",'2017-12-01'),
       ("Inception",'2010-08-16'),
       ("Monty Python and the Holy Grail",'1975-04-03');

/*Adding data into Genres table*/
INSERT INTO Genres (genre_name)
VALUES ("Action"),
       ("Adventure"),
       ("Thriller"),
       ("Science Fiction"),
       ("Drama"),
       ("Comedy");

/*Adding data into Movie Genres table*/
INSERT INTO Movie_Genres (movie_id,genre_id)
VALUES (1,1),
       (1,2),
       (1,3),
       (2,6),
       (2,5),
       (3,1),
       (3,2),
       (3,4),
       (4,6);

/*Adding data into Consumers table*/
INSERT INTO Consumers (consumer_first_name,consumer_last_name,consumer_address,consumer_city,consumer_state,consumer_zip_code)
VALUES ("Toru","Okada","800 Glenridge Ave","Hobart","IN","46343"),
       ("Kumiko","Okada","864 NW Bohemia St","Vincentown","NJ","08088"),
       ("Noboru","Wataya","342 Joy Ridge St","Hermitage","TN","37076"),
       ("May","Kasahara","5 Kent Rd","East Haven","CT","06512");

/*Adding data into Ratings table*/
INSERT INTO Ratings (movie_id,consumer_id,rating_when_rated,rating_star_number)
VALUES (1,1,'2010-09-02 10:54:19',4),
       (1,3,'2012-08-05 15:00:01',3),
       (1,4,'2016-10-02 23:58:12',1),
       (2,3,'2017-03-27 00:12:48',2),
       (2,4,'2018-08-02 00:54:42',4);

/*Joining the two to view the many to many relationship*/

SELECT movie_title, genre_name 
    FROM Movies
        NATURAL JOIN Movie_Genres
        NATURAL JOIN Genres;

-- Mril D'silva.