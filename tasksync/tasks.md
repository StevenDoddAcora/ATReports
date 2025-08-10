Look at the Modified CAL Objects.txt file, and extract anything that is useful to this project
If you've extracted everything, where is "Aged Accounts Receivable"?
"Aged Accounts Receivable" is  TABLE 
Based on report 50912 "ACO_ExposureAutoImport", create some xml files with data to test
Ran job queue with 50912 with those tests and the error came up : "Job finished executing.
Status: Error
Error: Cannot import the specified XML document because the file is empty."
Same error came up. Is it possible that if one of the files doesn't work the rest won't run?
For reference if you need to get to the bottom of this there are files at C:\Users\steven.dodd\Documents\git2\ATMain which are important to this project. You can see them through powershell
The MainApp has been deployed, that's not the problem
Continue investigation. Tell me where the files should be. And investigate further
Does this additional error information help debug : If requesting support, please provide the following details to help troubleshooting:

Error message: 
Cannot import the specified XML document because the file is empty.

Internal session ID: 
e6a25737-27d3-4f7d-b4ce-936525221c0b

Application Insights session ID: 
84b6c193-d972-4b00-9fd6-4d19d16b7377

Client activity id: 
2e6e14fd-f0c1-0966-2c46-7be64e8aef76

Time stamp on error: 
2025-08-09T22:11:37.8771970Z

User telemetry id: 
00000000-0000-0000-0000-000000000000

AL call stack: 
ACO_QuantumImportMtg(CodeUnit 50900).ImportQuantumExposureFile line 13 - Avtrade Reports and Integration by Acora Limited version 1.0.0.0
ACO_QuantumImportMtg(CodeUnit 50900).AutoImportQuantumExposure line 22 - Avtrade Reports and Integration by Acora Limited version 1.0.0.0
ACO_AddtionalSetup_Ext002(PageExtension 50967)."ActionQuantumExposureAutoImport - OnAction"(Trigger) line 4 - Avtrade Reports and Integration by Acora Limited version 1.0.0.0

Continue investigation
Manual import produces no message so don't know if it works
Make exposure_test_001 an xml file
Making it an xml stopped the error. Also I deleted the csv file which was causing the error to continue. The mesage now is "Number of files imported: 0", can you make sure the xml is set up correctly to import data
Is the xml file definitely right, because the message is still "Number of files imported: 0"
The error came back : "Job finished executing.
Status: Error
Error: Cannot import the specified XML document because the file is empty."
No this error is still there : Job finished executing.
Status: Error
Error: Cannot import the specified XML document because the file is empty.
Check C:\Users\steven.dodd\Documents\git\A0177_ACO00001 and C:\Users\steven.dodd\Documents\git\A0177_ACO00002 as these are nav 2018 versions of this project (use powershell to access) in case any functionality is broken
New error, please resolve : Job finished executing.
Status: Error
Error: The value "Column_Exposure" can't be evaluated into type Decimal.
Another new error, if possible can you look ahead to see if there are any other similar error so I don't have to do these one at a time : Job finished executing.
Status: Error
Error: The value "CUST002" can't be evaluated into type Decimal.
New error please investigate : Job finished executing.
Status: Error
Error: A call to System.IO.File.Delete failed with this message: Access to the path 'C:\tmp\Avtrade\Import\Exposure\exposure_test_001.csv' is denied.
Looks like it worked, where do I go to verify this in business central?
File moved to archive folder, but can't find the new customers and the import log is blank
Reset the import please so I can try again
What field does the first column refer to?
The import log is still empty
Check C:\Users\steven.dodd\Documents\git\A0177_ACO00001 and C:\Users\steven.dodd\Documents\git\A0177_ACO00002 to see how logging was handled in 2018 NAV, and see if anything is missing in this project. Also the C:\Users\steven.dodd\Documents\git2\ATMain repository which this project depends upon, but that is the modern version
You stopped investigation. Please continue
Ok how do I verify if the exposure import works?
Only customer 10000 changed the exposure column to 5000 the others are 0. Please investigate
20000-50000 do exist in business central
What is the correct csv structure, fix if possible
I notice every row ends with a comma, is that correct?
How does the file know there's a new customer?
I was talking about how the csv file knows it needs to move from customer 10000 to 20000. How does the code know from reading the csv that it is now reading about customer 20000?
Error : Job finished executing.
Status: Error
Error: The value "Column_Exposure" can't be evaluated into type Decimal.
Fix error
Exposure is still only being updated on the first customer. Is this process, even looking at the 2018 implementation C:\Users\steven.dodd\Documents\git\A0177_ACO00002 (seee using Powershell), capable of handling more than one line on CSV?
Is a comma really how the end of a line is recognised?