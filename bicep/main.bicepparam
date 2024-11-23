using 'main.bicep'

param application = 'record-store'
param sql_server_admin_username = 'dbadmin'
@secure()
param sql_server_admin_password = 'ABC123!@#ABC'
param sql_db_name = 'chinook'
