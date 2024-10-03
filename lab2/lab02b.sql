
/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS school;

CREATE DATABASE school;

/*Using our new school database*/
USE school;

/* Create the table with appropriate fields and assigned data types */
CREATE TABLE Instructors (
    PRIMARY KEY (instructor_id), /* Setting the Primary Key */
    instructor_id             INT AUTO_INCREMENT,
    instructor_first_name     VARCHAR(50),
    instructor_last_name      VARCHAR(50),
    instructor_campus_phone   VARCHAR(8)
);


/* Populate the tables with sample data */
INSERT INTO Instructors (instructor_first_name, instructor_last_name, instructor_campus_phone)
VALUES ('Kira', 'Bently', '363-9948'),
       ('Timothy', 'Ennis', '527-4992'),
       ('Shannon', 'Black', '322-5992'),
       ('Estela', 'Rosales', '322-6992');


SELECT * FROM Instructors; /* Creating a View to see table Instructors */

SELECT instructor_first_name, instructor_campus_phone AS 'Phone Directory' /* Creating a View to see the Phone Numbers */
  FROM Instructors;


/* End of file lab02b.sql */
