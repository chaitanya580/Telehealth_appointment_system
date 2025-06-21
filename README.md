# Telehealth_appointment_system
A program that manages a hospital's patient and doctor lists with their appointments 

1. Database Design and Relationships
The database is structured with tables for users (patients and doctors), specializations, appointments, doctor availability, consultation notes, notifications, audit logs, feedback, and waitlist. It also includes bonus tables for recurring appointments and external calendar events.

How it relates:
Users hold all patient and doctor information.
Specializations list medical specialties.
doctor_specializations links doctors to their specialties.
Appointments connect patients and doctors for bookings.
doctor_availability tracks when doctors are free.
Consultation_notes stores medical notes for each appointment.
Notifications send appointment reminders.
Audit logs record system actions.
Feedback collects patient ratings.
Waitlist manages patients waiting for fully booked doctors.
Recurring_appointments and external_calendar_events handle bonus features

Relationships:
Foreign keys connect tables.
Joins in queries pull together related data .

2. Instructions to Set Up and Test the System
   Instructions guide users on how to create the database, insert sample data, and run queries.

How it relates:
SQL file starts with the CREATE DATABASE and USE commands.
Tables are created with DDL statements.
Sample data is inserted with INSERT statements for users, specializations, appointments, etc.
Queries at the end let you test features: list patients, doctors, appointments, feedback, waitlist, etc.
Bonus queries and table additions (recurring, calendar, time zone) are included for extra features

3. List of Implemented Features (Core and Bonus)
What it means:
A summary of all features built into the system.
How it relates:
Core features:
User management (patients/doctors)
Appointment booking
Doctor availability
Consultation notes
Notifications
Audit logs
Feedback and ratings
Waitlisting

Bonus features:
Recurring appointments (series of bookings)
External calendar integration (simulated)
Time zone handling for appointments

