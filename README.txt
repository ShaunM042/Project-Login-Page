TRAIN RESERVATION SYSTEM - README
==================================

CREDENTIALS FOR TESTING:
========================

ADMIN ACCOUNT:
- Username: admin
- Password: admin123

CUSTOMER REPRESENTATIVE ACCOUNTS:
- Can be created by admin via Admin Dashboard > Manage Representatives
- Sample: Create rep with any SSN, name, and username/password

CUSTOMER ACCOUNTS:
- Register new customers via register.jsp
- Or use any existing customer credentials from your database

DATABASE SETUP:
===============

1. Database Name: reservation
2. MySQL Connection Details:
   - Host: localhost:3306
   - Username: root
   - Password: polk6699 (UPDATE THIS TO YOUR MYSQL PASSWORD)

3. Required Setup:
   - Import Dump20250707 (1).sql for base schema
   - Run schema_updates.sql for additional tables and sample data

IMPORTANT NOTES:
===============

1. DATABASE CONNECTION:
   - Uses centralized connection through dbConnection.jsp
   - Update password in dbConnection.jsp only (currently set to "polk6699")
   - All JSP files automatically use this centralized connection

2. SAMPLE DATA:
   - Schema includes sample train schedules and stations
   - Admin user is pre-created
   - Customer reps must be created via admin interface

FEATURES IMPLEMENTED:
====================

✓ Complete user registration and role-based authentication
✓ Train search with sorting and detailed stop information  
✓ Full reservation system with discounts and cancellation
✓ Comprehensive admin dashboard with reports and analytics
✓ Customer service Q&A system with search functionality
✓ All reporting features for sales, revenue, and customer analysis

TESTING WORKFLOW:
================

1. Login as admin → Create customer representatives
2. Login as customer → Search trains, make reservations
3. Login as rep → Manage schedules, answer customer questions
4. Test all reporting and analytics features

TECHNICAL DETAILS:
=================

- Java/JSP with MySQL backend
- Centralized database connection management (dbConnection.jsp)
- Role-based access control
- Responsive web interface
- SQL injection protection with PreparedStatements
- Session management
- Input validation
- Proper resource cleanup and error handling

All 100 points from the project checklist have been implemented and tested.