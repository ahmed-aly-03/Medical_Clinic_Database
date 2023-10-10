DROP TABLE bill;
DROP TABLE doc_prescribes_patient;
DROP TABLE appointment;
DROP TABLE patient;
DROP TABLE medication;
DROP TABLE doctor;
DROP TABLE schedule;
DROP TABLE nurse;
DROP VIEW Appointment_Info;
DROP VIEW Patient_Address;
DROP VIEW Bill_Status;


CREATE TABLE nurse(email VARCHAR(225) PRIMARY KEY,
                    password VARCHAR(20) NOT NULL, 
                    name VARCHAR(225) NOT NULL
);

CREATE TABLE schedule(schedule_id INT PRIMARY KEY,
                    day_of_shift VARCHAR(225) NOT NULL,
                    start_time VARCHAR(20) NOT NULL,
                    end_time VARCHAR(20) NOT NULL
);//ADD AUTO_INCREMENT

CREATE TABLE doctor(email VARCHAR(225) PRIMARY KEY,
                    nurse_email VARCHAR(225) NOT NULL,
                    schedule_id INT,
                    password VARCHAR(20) NOT NULL, 
                    name VARCHAR(225) NOT NULL,
                    FOREIGN KEY(nurse_email) REFERENCES nurse(email),
                    FOREIGN KEY(schedule_id) REFERENCES schedule(schedule_id)
);

CREATE TABLE medication(medication_id INT PRIMARY KEY,
                        name VARCHAR(60) NOT NULL,
                        instructions VARCHAR(225) NOT NULL,
                        price REAL NOT NULL
);//ADD AUTO_INCREMENT


CREATE TABLE patient(email VARCHAR(225) PRIMARY KEY,
                    doctor_email VARCHAR(225) NOT NULL, 
                    password VARCHAR(20) NOT NULL, 
                    name VARCHAR(225) NOT NULL, 
                    date_of_birth VARCHAR(225) NOT NULL, 
                    current_medication VARCHAR(225), 
                    street VARCHAR(225) NOT NULL,
                    city VARCHAR(225) NOT NULL,
                    province VARCHAR(7) NOT NULL,
                    postalcode VARCHAR(225) NOT NULL,
                    Reason VARCHAR(255) NOT NULL,
                    FOREIGN KEY(doctor_email) REFERENCES doctor(email)
);

CREATE TABLE appointment(appointment_id INT NOT NULL UNIQUE,
                        schedule_id INT ,
                        nurse_email VARCHAR(225),
                        patient_email VARCHAR(225),
                        room INT ,
                        PRIMARY KEY (room, schedule_id),
                        FOREIGN KEY(schedule_id) REFERENCES schedule(schedule_id),
                        FOREIGN KEY(patient_email) REFERENCES patient(email),
                        FOREIGN KEY(nurse_email) REFERENCES nurse(email)
);//ADD AUTO_INCREMENT 

CREATE TABLE doc_prescribes_patient(doctor_email VARCHAR(225), 
                                    medication_id INT NOT NULL ,
                                    quantity INT NOT NULL,
                                    appointment_ID NUMBER NOT NULL,
                                    FOREIGN KEY(appointment_ID) REFERENCES appointment(appointment_id),
                                    FOREIGN KEY(medication_id) REFERENCES medication(medication_id),
                                    FOREIGN KEY(doctor_email) REFERENCES doctor(email),    
                                    PRIMARY KEY(appointment_ID, medication_id, doctor_email)
);

CREATE TABLE bill(bill_id INT PRIMARY KEY,
                method_bill VARCHAR(30) NOT NULL,
                date__of_appointment VARCHAR(30),
                patient_email VARCHAR(225),
                base_cost REAL Default 100,
                status VARCHAR(30) DEFAULT 'NOT COMPLETE',
                FOREIGN KEY(patient_email) REFERENCES patient(email)
);

INSERT INTO nurse
VALUES('docSandra@tomu.ca', 'nurseS', 'Sandra');

INSERT INTO nurse
VALUES('docMariam@tomu.ca', 'nurseM', 'Mariam');

INSERT INTO nurse
VALUES('docJolie@tomu.ca', 'nurseJ', 'Jolie');

//SELECT * FROM nurse;

INSERT INTO schedule
VALUES(1, '2023-05-19', '8:00', '12:00');

INSERT INTO schedule
VALUES(2, '2023-05-20', '12:00', '16:00');

INSERT INTO schedule
VALUES(3, '2023-05-21', '16:00', '20:00');

//SELECT * FROM schedule;

INSERT INTO doctor
VALUES('docHanna@tomu.ca','docJolie@tomu.ca', 3,'docH', 'Hanna');

INSERT INTO doctor
VALUES('docDanny@tomu.ca','docSandra@tomu.ca', 2, 'docD', 'Danny');

INSERT INTO doctor 
VALUES('docMaged@tomu.ca','docMariam@tomu.ca' , 1,'docM', 'Maged');

SELECT * FROM doctor;

INSERT INTO medication
VALUES(1, 'Tylenol', 'Take 4 times a week', 43);

INSERT INTO medication
VALUES(2, 'Advil', 'Take 6 times a week', 50);

INSERT INTO medication
VALUES(3, 'Valium', 'Take 1 time a week', 100);

//SELECT * FROM medication;

INSERT INTO patient
VALUES('pabdalla@tomu.ca', 'docMaged@tomu.ca', '12345', 'Philip', '25/01/2003', 'Tylenol', '570 Hoover Park Drive', 'Toronto', 'Ontario', 'L4A 0S8', 'Knee Injury');

INSERT INTO patient
VALUES('AHMED@tomu.ca',  'docDanny@tomu.ca', '6789', 'Ahmed', '15/04/2003', NULL, 'Avenue Blvd', 'Toronto', 'Ontario', 'H2A 0S8', 'Cold');

INSERT INTO patient
VALUES('Miguel@tomu.ca', 'docHanna@tomu.ca' ,'34567', 'Miguel', '05/10/2003', NULL, 'Jane road', 'Vaughan', 'Ontario', '45S 4AS', 'COVID');

//SELECT * FROM patient;

INSERT INTO appointment
VALUES(1, 1, 'docMariam@tomu.ca', 'pabdalla@tomu.ca' ,1);

INSERT INTO appointment
VALUES(2, 2, 'docSandra@tomu.ca', 'AHMED@tomu.ca', 2);

INSERT INTO appointment
VALUES(3, 2, 'docJolie@tomu.ca', 'Miguel@tomu.ca', 3);


//SELECT * FROM appointment;

INSERT INTO doc_prescribes_patient
VALUES('docMaged@tomu.ca', 1, 10,1);

INSERT INTO doc_prescribes_patient
VALUES('docDanny@tomu.ca', 2, 2,1);

INSERT INTO doc_prescribes_patient
VALUES('docHanna@tomu.ca', 3, 4,2);

INSERT INTO doc_prescribes_patient
VALUES('docMaged@tomu.ca', 2, 2,2);


//SELECT * FROM doc_prescribes_patient;

INSERT INTO bill
VALUES(1, 'Credit', '09/01/2023', 'pabdalla@tomu.ca', 100, 'DONE');

INSERT INTO bill
VALUES(2, 'Credit', '09/02/2023', 'AHMED@tomu.ca', 100, 'NOT DONE');

INSERT INTO bill
VALUES(3, 'Credit', '09/03/2023', 'Miguel@tomu.ca', 100, 'DONE');

//SELECT * FROM bill;

//code for queries 
--Query 1
Select DISTINCT p.email AS Patient_Email, p.name AS Patient_Name, m.name AS medicine_name, quantity, day_of_shift AS date__of_appointment, instructions
FROM patient p , medication m, doc_prescribes_patient, appointment, schedule

WHERE p.email = appointment.patient_email  --To find all patients that have had an appointmnet

AND appointment.schedule_id = schedule.schedule_id --to ensure correct dates

AND appointment.appointment_id = doc_prescribes_patient.appointment_ID --These last two lines are find the perscriptions 

AND doc_prescribes_patient.medication_id = m.medication_id;

--Query 2
Select B.bill_id as Bill_ID, B.status as Bill_Status, p.name, B.base_cost AS Total_Cost
FROM patient p, Bill B, appointment, doc_prescribes_patient, medication m 

WHERE p.email = B.patient_email

AND  B.patient_email = appointment.Patient_Email

MINUS (Select B.bill_id as Bill_ID, B.status as Bill_Status, p.name, B.base_cost AS Total_Cost
FROM  patient p, Bill B, appointment, doc_prescribes_patient, medication m 

WHERE p.email = B.patient_email

AND  B.patient_email = appointment.Patient_Email 

AND appointment.appointment_id = doc_prescribes_patient.appointment_ID)

UNION 

Select B.bill_id as Bill_ID, B.status as Bill_Status, p.name, SUM((m.price*doc_prescribes_patient.quantity))+ B.base_cost AS Total_Cost
FROM patient p, Bill B, appointment, doc_prescribes_patient, medication m 

WHERE p.email = B.patient_email

AND  B.patient_email = appointment.Patient_Email 

AND appointment.appointment_id = doc_prescribes_patient.appointment_ID

AND doc_prescribes_patient.medication_id = m.medication_id 

GROUP BY
B.bill_id, B.status, p.name, B.base_cost

ORDER BY Bill_ID;

--Query 3
SELECT name AS Patient_Name ,province AS Province, city AS City, street AS Street, postalcode AS Postal_Code
FROM patient;

--Query 4
SELECT DISTINCT d.name AS Doctor_Name, n.name AS Nurse_Name, p.name AS Patient_Name, s.day_of_shift, s.start_time, s.end_time, a.room
FROM doctor d, nurse n, schedule s, appointment a, patient p
WHERE  n.email = d.nurse_email AND
       s.schedule_id = a.schedule_id AND
       p.doctor_email = d.email and
       a.nurse_email = n.email
       ORDER BY room;
  
    
--Query 5
SELECT name, email, password
FROM nurse;

--Query 6
SELECT name, email, password
FROM doctor;

--Query 7 
SELECT name, email, password
FROM patient;

--Query 8 
SElECT DISTINCT d.name as Doctor_Name, p.name AS Patient_Name, s.day_of_shift as dateofshift, Reason
FROM doctor d, appointment a, patient p, schedule s

WHERE p.doctor_email = d.email 
    
    AND   d.nurse_email = a.nurse_email

    AND   a.schedule_id = s.schedule_id
    
    AND p.name = 'Philip';
  
--Query 9 
SELECT d.name AS "DOCTOR", n.name AS "NURSE", p.name AS "PATIENT", b.date__of_appointment AS "APPOINTMENT DATE"
FROM doctor d, nurse n, patient p, bill b
WHERE n.email = d.nurse_email

    AND d.email = p.doctor_email
  
    AND p.email = b.patient_email;

--Query 10 
SELECT m.name, m.instructions
FROM medication m;

--Query 11 
SELECT p.name AS Patients_With_Unpaid_Bills, p.email AS Patient_Email 
FROM Bill B, patient p
WHERE B.status = 'NOT DONE'

    AND B.patient_email = p.email;

--View 1 (For Query 2)
CREATE VIEW Bill_Status AS 
Select B.bill_id as Bill_ID, B.status as Bill_Status, p.name, B.base_cost AS Total_Cost
FROM patient p, Bill B, appointment, doc_prescribes_patient, medication m 

WHERE p.email = B.patient_email

AND  B.patient_email = appointment.Patient_Email

MINUS 

Select B.bill_id as Bill_ID, B.status as Bill_Status, p.name, B.base_cost AS Total_Cost
FROM  patient p, Bill B, appointment, doc_prescribes_patient, medication m 

WHERE p.email = B.patient_email

AND  B.patient_email = appointment.Patient_Email 

AND appointment.appointment_id = doc_prescribes_patient.appointment_ID

UNION 

Select B.bill_id as Bill_ID, B.status as Bill_Status, p.name, SUM((m.price*doc_prescribes_patient.quantity))+ B.base_cost AS Total_Cost
FROM patient p, Bill B, appointment, doc_prescribes_patient, medication m 

WHERE p.email = B.patient_email

AND  B.patient_email = appointment.Patient_Email 

AND appointment.appointment_id = doc_prescribes_patient.appointment_ID

AND doc_prescribes_patient.medication_id = m.medication_id 

GROUP BY
B.bill_id, p.name, B.status, B.base_cost

ORDER BY Bill_ID

WITH READ ONLY;

SELECT * FROM Bill_Status;

--View 2 (For Query 3)
CREATE VIEW Patient_Address AS 
SELECT name AS Patient_Name ,province AS Province, city AS City, street AS Street, postalcode AS Postal_Code
FROM patient
       WITH READ ONLY;
       
SELECT * FROM Patient_Address;

--View 3
CREATE VIEW Appointment_Info AS 
SELECT DISTINCT d.name AS Doctor_Name, n.name AS Nurse_Name, p.name AS Patient_Name, s.day_of_shift, s.start_time, s.end_time, a.room
FROM doctor d, nurse n, schedule s, appointment a, patient p
WHERE  n.email = d.nurse_email AND
       s.schedule_id = a.schedule_id AND
       p.doctor_email = d.email and
       a.nurse_email = n.email
       ORDER BY room
       
       WITH READ ONLY;
       
SELECT * FROM Appointment_Info;