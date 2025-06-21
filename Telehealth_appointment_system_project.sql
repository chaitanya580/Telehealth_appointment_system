CREATE DATABASE telehealth_appointment_project;
USE telehealth_appointment_project;

-- Users table (stores both doctors and patients)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    is_doctor BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Specializations table
CREATE TABLE specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Doctor specializations (many-to-many relationship)
CREATE TABLE doctor_specializations (
    doctor_id INT,
    specialization_id INT,
    PRIMARY KEY (doctor_id, specialization_id),
    FOREIGN KEY (doctor_id) REFERENCES users(user_id),
    FOREIGN KEY (specialization_id) REFERENCES specializations(specialization_id)
);

-- Appointments table
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_datetime DATETIME NOT NULL,
    meeting_type ENUM('In-person', 'Virtual') NOT NULL,
    virtual_link VARCHAR(255),
    status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES users(user_id)
);

-- Doctor availability slots
CREATE TABLE doctor_availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status ENUM('Available', 'Booked') NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES users(user_id)
);

-- Consultation notes
CREATE TABLE consultation_notes (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    notes TEXT,
    prescription TEXT,
    outcome TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Notifications
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    user_id INT,
    message TEXT NOT NULL,
    status ENUM('Sent', 'Pending', 'Read') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Audit logs
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Feedback
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Waitlist
CREATE TABLE waitlist (
    waitlist_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    preferred_date DATE NOT NULL,
    status ENUM('Waiting', 'Booked', 'Cancelled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES users(user_id)
);

-- DML 
-- Adding  users (doctors and patients)
INSERT INTO users (name, email, phone, password_hash, is_doctor)
VALUES
    ('Dr. Smith', 'smith@example.com', '1234567890', 'hash1', TRUE),
    ('Dr. Lee', 'lee@example.com', '2345678901', 'hash2', TRUE),
    ('Dr. Jeff Brennan', 'brennan@example.com', '3456789012', 'hash6', TRUE),
    ('Aditi', 'aditi@example.com', '9000000009', 'hash3', FALSE),
    ('Rohan', 'rohan@example.com', '9000000010', 'hash4', FALSE),
    ('Meera', 'meera@example.com', '9000000011', 'hash5', FALSE),
    ('Chaitanya Kumar', 'chaitanya@example.com', '8000000008', 'hash7', FALSE);

-- Add specializations
INSERT INTO specializations (name)
VALUES
    ('Cardiology'),
    ('Pediatrics'),
    ('Neurology'),
    ('General Medicine');

-- Assign specializations to doctors
INSERT INTO doctor_specializations (doctor_id, specialization_id)
VALUES
    (1, 1), -- Dr. Smith is a Cardiologist
    (2, 2), -- Dr. Lee is a Pediatrician
    (3, 4); -- Dr. Jeff Brennan is in General Medicine

-- Add doctor availability
INSERT INTO doctor_availability (doctor_id, available_date, start_time, end_time, status)
VALUES
    (1, '2025-06-21', '09:00:00', '17:00:00', 'Available'),
    (2, '2025-06-21', '08:00:00', '16:00:00', 'Available'),
    (3, '2025-06-21', '10:00:00', '19:00:00', 'Available'),
    (3, '2025-06-22', '09:00:00', '17:00:00', 'Available');

-- Book appointments (using new patient and doctor IDs)
INSERT INTO appointments (patient_id, doctor_id, appointment_datetime, meeting_type, virtual_link, status)
VALUES
    (4, 1, '2025-06-21 09:30:00', 'Virtual', 'https://zoom.us/meet/abc123', 'Scheduled'), -- Aditi with Dr. Smith
    (5, 2, '2025-06-21 10:00:00', 'Virtual', 'https://zoom.us/meet/xyz456', 'Scheduled'), -- Rohan with Dr. Lee
    (7, 3, '2025-06-21 11:00:00', 'Virtual', 'https://zoom.us/meet/def789', 'Scheduled'); -- Chaitanya Kumar with Dr. Jeff Brennan

-- Add consultation notes
INSERT INTO consultation_notes (appointment_id, notes, prescription, outcome)
VALUES
    (1, 'Patient had mild fever.', 'Paracetamol 500mg', 'Recovered'),
    (3, 'General checkup completed. Blood pressure normal.', 'Advise regular exercise and balanced diet.', 'Healthy');

-- Add notifications
INSERT INTO notifications (appointment_id, user_id, message, status)
VALUES
    (1, 4, 'Appointment reminder: Your consultation is tomorrow at 09:30.', 'Sent'),
    (3, 7, 'Appointment reminder: Your consultation is today at 11:00.', 'Sent');

-- Add audit logs
INSERT INTO audit_logs (user_id, action, table_name, record_id)
VALUES
    (4, 'CREATE', 'appointments', 1),
    (7, 'CREATE', 'appointments', 3);

-- Add feedback (ensure appointment_id exists!)
INSERT INTO feedback (appointment_id, rating, comments)
VALUES
    (1, 4, 'Very professional and attentive.'),
    (3, 5, 'Excellent bedside manner and clear advice.');

-- Add to waitlist
INSERT INTO waitlist (patient_id, doctor_id, preferred_date, status)
VALUES
    (6, 1, '2025-06-21', 'Waiting'), -- Meera on waitlist for Dr. Smith
    (7, 2, '2025-06-22', 'Waiting'); -- Chaitanya Kumar on waitlist for Dr. Lee (example)
    
    -- CORE Quries
-- List all patients in the system 
SELECT user_id, name, email, phone
FROM users
WHERE is_doctor = FALSE;

-- List all doctors in the system
SELECT user_id, name, email, phone
FROM users
WHERE is_doctor = TRUE;

-- List doctors along with their specializations for easy reference
SELECT u.user_id, u.name, s.name AS specialization
FROM users u
JOIN doctor_specializations ds ON u.user_id = ds.doctor_id
JOIN specializations s ON ds.specialization_id = s.specialization_id;

-- Show upcoming appointments with patient and doctor names, and appointment details
SELECT
  a.appointment_id,
  p.name AS patient_name,
  d.name AS doctor_name,
  a.appointment_datetime,
  a.meeting_type,
  a.status
FROM appointments a
JOIN users p ON a.patient_id = p.user_id
JOIN users d ON a.doctor_id = d.user_id
WHERE a.status = 'Scheduled';

-- Display available time slots for a specific doctor (here, doctor_id = 1)
SELECT available_date, start_time, end_time
FROM doctor_availability
WHERE doctor_id = 1 AND status = 'Available';

-- List all appointments scheduled as virtual meetings with their virtual links
SELECT appointment_id, patient_id, doctor_id, appointment_datetime, virtual_link
FROM appointments
WHERE meeting_type = 'Virtual';

-- Retrieve consultation records with patient and doctor names for comprehensive patient history
SELECT
  cn.notes,
  cn.prescription,
  cn.outcome,
  p.name AS patient_name,
  d.name AS doctor_name
FROM consultation_notes cn
JOIN appointments a ON cn.appointment_id = a.appointment_id
JOIN users p ON a.patient_id = p.user_id
JOIN users d ON a.doctor_id = d.user_id;

-- BONUS queries
-- List all notifications for  user_id = 3  with appointment details
SELECT n.message, n.status, a.appointment_datetime
FROM notifications n
JOIN appointments a ON n.appointment_id = a.appointment_id
WHERE n.user_id = 3;

-- List all patients currently on the waitlist, with their preferred doctor and date
SELECT p.name AS patient_name, d.name AS doctor_name, w.preferred_date, w.status
FROM waitlist w
JOIN users p ON w.patient_id = p.user_id
JOIN users d ON w.doctor_id = d.user_id;

-- Calculate and display average ratings for each doctor based on patient feedback
SELECT d.user_id, d.name, AVG(f.rating) AS avg_rating
FROM users d
JOIN appointments a ON d.user_id = a.doctor_id
JOIN feedback f ON a.appointment_id = f.appointment_id
GROUP BY d.user_id, d.name;

-- Show recent audit log entries for tracking system activity
SELECT u.name, a.action, a.table_name, a.record_id, a.timestamp
FROM audit_logs a
JOIN users u ON a.user_id = u.user_id
ORDER BY a.timestamp DESC
LIMIT 10;

-- Add a table to manage recurring appointment patterns
CREATE TABLE recurring_appointments (
    recurring_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    start_datetime DATETIME NOT NULL,
    recurrence_pattern VARCHAR(50), -- e.g., 'WEEKLY', 'MONTHLY'
    occurrences INT, -- Number of times to repeat
    FOREIGN KEY (patient_id) REFERENCES users(user_id),
    FOREIGN KEY (doctor_id) REFERENCES users(user_id)
);

-- Link appointments to recurring series
ALTER TABLE appointments
ADD COLUMN recurring_id INT,
ADD FOREIGN KEY (recurring_id) REFERENCES recurring_appointments(recurring_id);

-- Create a weekly recurring appointment for 4 weeks
INSERT INTO recurring_appointments (patient_id, doctor_id, start_datetime, recurrence_pattern, occurrences)
VALUES (7, 3, '2025-06-22 10:00:00', 'WEEKLY', 4);

-- Insert first appointment in the series
INSERT INTO appointments (patient_id, doctor_id, appointment_datetime, meeting_type, virtual_link, status, recurring_id)
VALUES (7, 3, '2025-06-22 10:00:00', 'Virtual', 'https://zoom.us/meet/rec1', 'Scheduled', 1);

-- Table to simulate external calendar events integration
CREATE TABLE external_calendar_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    calendar_provider VARCHAR(50), -- e.g., 'Google Calendar'
    external_event_id VARCHAR(100), -- Simulated external ID
    synced_at DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Simulate syncing an appointment with Google Calendar
INSERT INTO external_calendar_events (appointment_id, calendar_provider, external_event_id, synced_at)
VALUES (3, 'Google Calendar', 'gcal_event_12345', NOW());

-- Add a time_zone column to the appointments table
ALTER TABLE appointments
ADD COLUMN time_zone VARCHAR(50) DEFAULT 'UTC';

-- Book an appointment with a specific time zone
INSERT INTO appointments (patient_id, doctor_id, appointment_datetime, meeting_type, virtual_link, status, time_zone)
VALUES (7, 3, '2025-06-22 10:00:00', 'Virtual', 'https://zoom.us/meet/def789', 'Scheduled', 'Asia/Kolkata');

-- List all appointments with their time zones
SELECT appointment_id, appointment_datetime, time_zone
FROM appointments;





















