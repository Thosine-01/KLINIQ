I am building a Clinic App that have three roles
1st role - The Patient
2nd role - The Clinicians
3rd role - The Administrators
Each of this roles sees and have access to different slice of the data and the point of this project is to enforce the slice correctly.

The patient can only see and read his/her own records and cannot see records of other patients.

The Clinicians can write and have access to records of patients only in their care. ie they dont have the reocords of other patients which are not i their care.

The administrator have access to the operational data and audit logs. they cn see the list of patience records but cannot open to read it.

concepts to know
differnce btw relationship check and role check
column level restriction

The single most damaging mistake is a patient reading another patient records