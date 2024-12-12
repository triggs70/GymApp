drop database if exists GymApp;
Create database GymApp;
use GymApp;

create table if not exists users ( 
	userID int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
    passwordHash varchar(255) not null,
    registeredOn timestamp default current_timestamp,
    isAdmin boolean default false
    );

create table if not exists workoutCategory (
	categoryID int auto_increment primary key,
    categoryName varchar(100) not null unique
    );

create table if not exists workouts (
	workoutId int auto_increment primary key,
    userID int not null,
    categoryID int not null,
    workoutDate date not null,
    notes text,
    createdOn timestamp default current_timestamp,
    foreign key (categoryID) references workoutCategory (categoryID) on delete cascade,
    foreign key (userID) references users (userID) on delete cascade
    );
    
create table if not exists exercises (
	exerciseID int auto_increment primary key,
    workoutID int not null,
    exerciseName varchar(100) not null,
    foreign key (workoutID) references workouts (workoutID) on delete cascade
    );
    
create table if not exists exerciseSets (
	setsID int auto_increment primary key,
    exerciseID int not null,
    setNumber int not null,
    reps int not null,
    weight decimal(5,2) not null,
    foreign key (exerciseID) references exercises (exerciseID) on delete cascade
    );
    
    
-- Indexing for highly populated tables 
create index idxUserID on workouts (userID);
create index idxWorkoutDate on workouts (workoutDate);
create index idxWorkoutID on exercises (workoutID);
create index idxExerciseID on exerciseSets (exerciseID);

    
-- Views    
create view userExerciseHistory as 
	select w.userID, e.exerciseName, w.workoutDate, s.setNumber, s.reps, s.weight
    from workouts w
    join exercises e on w.workoutID = e.workoutID
    join exerciseSets s on e.exerciseID = s.exerciseID
    order by e.exerciseName, w.workoutDate, s.setNumber;
    
create view workoutDetails as 
	select w.workoutID, w.userID, w.workoutDate, w.notes, c.categoryName as workoutCategory, e.exerciseName, s.setNumber, s.weight, s.reps
    from workouts w 
    join workoutCategory c on w.categoryID = c.categoryID
    join exercises e on w.workoutID = e.workoutID
    join exerciseSets s on e.exerciseID = s.exerciseID;
    
create view recentWorkouts as
	select w.userID, w.workoutDate, c.categoryName, w.notes
    from workouts w
    join workoutCategory c on w.categoryID = c.categoryID
    order by w.workoutDate desc;
    

    
    
    
    
    
    
    
/* -- Sample Data
INSERT INTO users (username, email, firstName, lastName, passwordHash, isAdmin)
VALUES 
('john_doe', 'john@example.com', 'John', 'Doe', 'hashed_password1', false),
('jane_smith', 'jane@example.com', 'Jane', 'Smith', 'hashed_password2', false),
('admin_user', 'admin@example.com', 'Admin', 'User', 'hashed_password3', true);

INSERT INTO workoutCategory (categoryName)
VALUES 
('Chest Day'), ('Leg Day'), ('Back Day'), ('Cardio Day'), ('Upper Day');

INSERT INTO workouts (userID, categoryID, workoutDate, notes)
VALUES 
(1, 1, '2024-12-10', 'Focused on bench press and chest flyes'),
(1, 2, '2024-12-11', 'Squat progression day'),
(2, 3, '2024-12-12', 'Pull-up and row-focused session'),
(2, 5, '2024-12-13', 'Upper body strength training');

INSERT INTO exercises (workoutID, exerciseName)
VALUES 
(1, 'Barbell Bench Press'),
(1, 'Incline Dumbbell Flyes'),
(2, 'Back Squat'),
(2, 'Leg Press'),
(3, 'Pull-Ups'),
(3, 'Bent Over Rows'),
(4, 'Overhead Press'),
(4, 'Lat Pulldowns');

INSERT INTO exerciseSets (exerciseID, setNumber, reps, weight)
VALUES 
(1, 1, 12, 135.00), -- Barbell Bench Press
(1, 2, 10, 145.00),
(1, 3, 8, 155.00),
(2, 1, 15, 30.00), -- Incline Dumbbell Flyes
(2, 2, 12, 35.00),
(3, 1, 10, 185.00), -- Back Squat
(3, 2, 8, 205.00),
(4, 1, 15, 200.00), -- Leg Press
(4, 2, 12, 250.00),
(5, 1, 12, 0.00), -- Pull-Ups (bodyweight)
(6, 1, 10, 95.00), -- Bent Over Rows
(6, 2, 8, 115.00),
(7, 1, 10, 65.00), -- Overhead Press
(8, 1, 12, 80.00); -- Lat Pulldowns


SELECT * FROM excerciseProgress WHERE exerciseName = 'Barbell Bench Press'; -- Progress View 
SELECT * FROM workoutDetails WHERE workoutDate = '2024-12-10'; -- WorkoutDetails View
SELECT * FROM workoutDetails WHERE userID = 1 ORDER BY workoutDate DESC; -- Recent Workouts for a user 
*/

