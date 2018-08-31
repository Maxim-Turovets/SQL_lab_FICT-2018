/*
1.	Створити базу даних з ім’ям, що відповідає вашому прізвищу англійською мовою.
2.	Створити в новій базі таблицю Student з атрибутами StudentId, SecondName, FirstName, Sex. Обрати для них оптимальний тип даних в вашій СУБД.
3.	Модифікувати таблицю Student. Атрибут StudentId має стати первинним ключем.
4.	Модифікувати таблицю Student. Атрибут StudentId повинен заповнюватися автоматично починаючи з 1 і кроком в 1.
5.	Модифікувати таблицю Student. Додати необов’язковий атрибут BirthDate за відповідним типом даних.
6.	Модифікувати таблицю Student. Додати атрибут CurrentAge, що генерується автоматично на базі існуючих в таблиці даних.
7.	Реалізувати перевірку вставлення даних. Значення атрибуту Sex може бути тільки ‘m’ та ‘f’.
8.	В таблицю Student додати себе та двох «сусідів» у списку групи. 
9.	Створити  представлення vMaleStudent та vFemaleStudent, що надають відповідну інформацію. 
10.	Змінити тип даних первинного ключа на TinyInt (або SmallInt) не втрачаючи дані.
*/

/*Завдання 1*/

  CREATE DATABASE Turovets;

/*Завдання 2*/

  CREATE TABLE Students
	 (
		Student_id    INT NOT NULL,
		SecondName    NCHAR(45) NOT NULL,
		FirstName     NCHAR(45) NOT NULL,
		Sex           NCHAR(5) NOT NULL
	 );

/*Завдання 3*/

        ALTER TABLE dbo.Students ADD CONSTRAINT
	 PriKey_Student_id PRIMARY KEY (Student_id);

/*Завдання 4*/

	ALTER TABLE Students 
	 DROP CONSTRAINT PriKey_Student_id

        ALTER TABLE Students 
	 DROP COLUMN Student_id 

        ALTER TABLE Students 
	 ADD Student_id INT IDENTITY(1,1)

        ALTER TABLE Students 
	 ADD CONSTRAINT PriKey_Student_id PRIMARY KEY (Student_id)

/*Завдання 5*/

	ALTER TABLE Students
	 ADD BirthDate DATE;

/*Завдання 6*/

	ALTER TABLE Students
	 ADD CurrentAge AS (DATEDIFF(month, BirthDate, GETDATE())/12)

/*Завдання 7*/

	ALTER TABLE dbo.Students ADD CONSTRAINT CK_Sex
	 CHECK(Sex = 'm' OR Sex = 'f');

/*Завдання 8*/

	INSERT INTO Students (SecondName, FirstName, Sex)VALUES
	 ('Nevmerzhitsky', 'Andrew', 'm'),
	 ('Turovets', 'Maxim', 'm'),
	 ('Tsitsilyuk', 'Anna', 'f');

/*Завдання 9*/
	CREATE VIEW vMaleStudent AS
	 (
          SELECT * FROM Students
           WHERE Sex LIKE 'm'
	 )
  GO

        CREATE VIEW vFemaleStuden AS
	 (
          SELECT * FROM Students
           WHERE Sex LIKE 'f'
	 )
  GO

/*Завдання 10*/

IF (SELECT MAX(Student.Student_id) FROM Students) <= 255
BEGIN
  ALTER TABLE Students 
	DROP CONSTRAINT PriKey_Student_id

      ALTER TABLE Students
       ALTER COLUMN Student_id TinyInt

      ALTER TABLE Students
       ADD PRIMARY KEY (Student_id)
END



	 
