# RDI-project
* All the elements of this project are created and tested on RDI. 
* Funtionality - This project is a banking system called "RDI bank" where user can login either as an ADMIN or a CUSTOMER. Based on his role, next screen containing all the eligible members of that bank will be wil be displayed. A Customer can only see his record and deposit/withdraw money. An admin can see all the members of the bank and can do manuplations on any of the member's bank balance.  
* Elements used:
* * Physical files: This project has two physical files. ADMINPF is used to validate login details, and CUSTOMERPF is used to display/save customer details and bank balance.  
* * Display files: I have used two display files. "BANKD" for the login, and "BALANCED" to display customer details and balance. There is a window also which is used to deposit or withdraw money. 
* * Programs: This project has used an ILE program RDIBANK with 2 modules attached to it. Various subroutines are used to logically bind the code for easy understanding. 
* * Modules: There are two modules used. "RDIBANK" to validate login details and then control transfered to "RDIBANK2" for further processing. Procedure call is used to call RDIBANK2. 
* * Sub-procedure: ADD subprocedure is used for deposit and SUB subprocedure is used for withdrawl process. 
* Activation group: NEW activation group is used for this project. 
