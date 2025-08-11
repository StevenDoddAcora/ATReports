✅ **COMPLETED**: Check C:\Users\steven.dodd\Documents\git\A0177_ACO00002 using powershell to see how the import log is handled. If that is missing or not implemented in a way that will work please implement

**RESOLUTION**: Import log functionality properly implemented. ATReports uses ACO_ImportLog from "AvTrade Core Application" dependency (correct approach). NAV 2018 missing table not our concern. Exposure imports use direct CSV processing approach.

✅ **COMPLETED**: For completeness there might be an import log at C:\Users\steven.dodd\Documents\git2\ATMain (look using powershell), which this extension is dependant on

**RESOLUTION**: Found ATMain Table 50104 ACO_ImportLog implementation. ATReports correctly uses dependency instead of duplicating table. Architecture verified as working correctly.

I've tried running the tests on the Additional Setup page. Make sure there is sufficient test date for these tests, create them if necessary 

Tried to run the auto invoice import test and got this message "Cannot import the specified XML document because the file is empty.". I think the import isn't working correctly. Check the 2018 method, and possibly the auto exposure import which now seems to work, and correct if necessary 

Getting error : A call to System.IO.File.Delete failed with this message: Access to the path 'C:\tmp\Avtrade\Import\Invoice\test_invoice_data.csv' is denied. Probably more permissions errors in C:\tmp\Avtrade\, can you fix please

Got this message : 
IMPORT SUMMARY:
No. of documents in file(s): 1
No. of documents created: 0
No. of documents posted: 0