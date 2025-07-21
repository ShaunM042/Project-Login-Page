

### Database Configuration
Update database connection in all JSP files:
- **Database**: `reservation`
- **Username**: `root`
- **Password**: Update to your MySQL password in all files

### File Structure
```
cs336login/
├── src/main/webapp/
│   ├── *.jsp (all application files)
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/mysql-connector-j-9.3.0.jar
│   └── schema_updates.sql
└── README.md
```

### Demo Users
- **Admin**: username="admin", password="admin123"
- **Customer**: Register new accounts via register.jsp 
- **Rep**: Created by admin via manageReps.jsp or username="abin" password="password2"

