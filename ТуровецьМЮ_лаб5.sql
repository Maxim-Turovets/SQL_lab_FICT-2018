/*
1.	�������� ���� ����� � ����, �� ������� ������ ������� ���������� �����.
2.	�������� � ���� ��� ������� Student � ���������� StudentId, SecondName, FirstName, Sex. ������ ��� ��� ����������� ��� ����� � ����� ����.
3.	������������ ������� Student. ������� StudentId �� ����� ��������� ������.
4.	������������ ������� Student. ������� StudentId ������� ������������� ����������� ��������� � 1 � ������ � 1.
5.	������������ ������� Student. ������ ������������� ������� BirthDate �� ��������� ����� �����.
6.	������������ ������� Student. ������ ������� CurrentAge, �� ���������� ����������� �� ��� �������� � ������� �����.
7.	���������� �������� ���������� �����. �������� �������� Sex ���� ���� ����� �m� �� �f�.
8.	� ������� Student ������ ���� �� ���� ������ � ������ �����. 
9.	��������  ������������� vMaleStudent �� vFemaleStudent, �� ������� �������� ����������. 
10.	������ ��� ����� ���������� ����� �� TinyInt (��� SmallInt) �� ��������� ���.
*/

/*�������� 1*/

  CREATE DATABASE Turovets;

/*�������� 2*/

  CREATE TABLE Students
	 (
		Student_id    INT NOT NULL,
		SecondName    NCHAR(45) NOT NULL,
		FirstName     NCHAR(45) NOT NULL,
		Sex           NCHAR(5) NOT NULL
	 );

/*�������� 3*/

        ALTER TABLE dbo.Students ADD CONSTRAINT
	 PriKey_Student_id PRIMARY KEY (Student_id);

/*�������� 4*/

	ALTER TABLE Students 
	 DROP CONSTRAINT PriKey_Student_id

        ALTER TABLE Students 
	 DROP COLUMN Student_id 

        ALTER TABLE Students 
	 ADD Student_id INT IDENTITY(1,1)

        ALTER TABLE Students 
	 ADD CONSTRAINT PriKey_Student_id PRIMARY KEY (Student_id)

/*�������� 5*/

	ALTER TABLE Students
	 ADD BirthDate DATE;

/*�������� 6*/

	ALTER TABLE Students
	 ADD CurrentAge AS (DATEDIFF(month, BirthDate, GETDATE())/12)

/*�������� 7*/

	ALTER TABLE dbo.Students ADD CONSTRAINT CK_Sex
	 CHECK(Sex = 'm' OR Sex = 'f');

/*�������� 8*/

	INSERT INTO Students (SecondName, FirstName, Sex)VALUES
	 ('Nevmerzhitsky', 'Andrew', 'm'),
	 ('Turovets', 'Maxim', 'm'),
	 ('Tsitsilyuk', 'Anna', 'f');

/*�������� 9*/
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

/*�������� 10*/

IF (SELECT MAX(Student.Student_id) FROM Students) <= 255
BEGIN
  ALTER TABLE Students 
	DROP CONSTRAINT PriKey_Student_id

      ALTER TABLE Students
       ALTER COLUMN Student_id TinyInt

      ALTER TABLE Students
       ADD PRIMARY KEY (Student_id)
END



	 
