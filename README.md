# Presencia — Attendance Management System

## Project Description

Presencia is a web-based attendance management application developed for **Université Amar Telidji — Laghouat**.

The main objective of this project is to simplify and digitalize the student attendance process inside the university.  
Instead of using manual attendance sheets, professors can log into the platform, access their assigned courses, display enrolled students, and register attendance for each teaching session.

This application was developed as part of a web application development academic project and combines both front-end and back-end concepts studied during the course.

---

## Technologies Used

The Presencia project was developed using the following technologies:

### Front-end
- **JavaServer Pages (JSP)** for dynamic web page rendering
- **HTML** for page structure
- **CSS** for user interface styling
- **JavaScript** for client-side interactivity
- **JSP Includes** for reusable components (header, footer, sidebar)

### Back-end
- **Java 17**
- **Spring Boot 2.7**
- **Spring MVC**
- **JDBC**
- **MySQL 8**
- **bcrypt** for password hashing
- **Maven** for dependency and build management

### Development Tools
- **Ngrok** for external local server testing
- **CORS configuration** for secure request handling

---

## Setup and Execution Instructions

### 1. Clone the Project

```bash
git clone https://github.com/SerineBouakkaz/presencia.git
cd presencia
```

---

### 2. Create the Database

Open MySQL and execute the following command:

```sql
CREATE DATABASE presencia_db;
```

---

### 3. Execute SQL Scripts

Run the following SQL files in this exact order:

```bash
src/main/resources/db/schema.sql
src/main/resources/db/migration.sql
src/main/resources/db/import_professors.sql
src/main/resources/db/courses_import.sql
src/main/resources/db/import_l2_students.sql
```

These scripts will create the tables and import the initial data.

---

### 4. Configure Database Connection

Open the file:

```bash
src/main/resources/application.yml
```

Then configure your MySQL username and password:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/presencia_db
    username: YOUR_USER
    password: YOUR_PASSWORD
```

---

### 5. Run the Application

Open terminal in the project folder and execute:

```bash
mvn spring-boot:run
```

After successful startup, open the browser at:

```bash
http://localhost:8081
```

---

## Default Login Credentials

| Email | Password |
|-------|----------|
| boudouh.sarra@univ-laghouat.dz | Presencia@2026 |

---

## Project Structure

```bash
src/main/java/com/presencia/
├── controller/
├── dao/
├── model/
├── service/
├── interceptor/
└── config/
```

---

## Developed by:

Maria Serinne Bouakkaz
Amra Leila Gasselaoud
Aboubacar Rabo Ammar
Youcef Benhorma
Rafik Nadjame
Computer Science Student
