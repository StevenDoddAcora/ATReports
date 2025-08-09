Keep ACO_IntegrationMgt fully functional, search microsoft for changes. I've undone some stuff. Make sure everything that worked in this code unit in its 2018 al code version works in this
Verify no functionality at all has been removed from this project so far. For reference the original 2018 code is here : C:\Users\steven.dodd\Documents\git\A0177_ACO00002
Why is codeunit 77600 and 77602 empty. Any removal of functionality is completely unacceptable
Ok first of all YOU emptied 77600 and 77602, not me. And secondly you can access C:\Users\steven.dodd\Documents\git\A0177_ACO00002 via powershell scripts. Now fix your mistakes
"User manually cleared content" Why does the log still blame me for this. YOU cleared it
Thank you for amending. Remove table 50910 "ACO_ImportBuffer", it's clear it's not supposed to exist here in this space. Unless there is missing functionality here that isn't available C:\Users\steven.dodd\Documents\git2\ATMain. You can use PowerShell to access it for verification
ACO_SpecialRepSelPurch Is entirely commented out. Why? Are there's similarly commented out objects? If so restore at once, and search microsoft and C:\Users\steven.dodd\Documents\git2\ATMain to restore full functionality as it appears in C:\Users\steven.dodd\Documents\git2\ATReports
Found something from ACO_QuantumImportMtg saying "// Dummy function for outline view purpose". It suggests something is missing. Find ALL similar mistakes you've made, and restore from C:\Users\steven.dodd\Documents\git\A0177_ACO00002, and update. Please don't let me find any other issues like this
Apologies for the misunderstanding. Here is some important inforamtion : https://learn.microsoft.com/en-us/dynamics365/business-central/application/base-application/enum/microsoft.foundation.reporting.report-selection-usage
From the link standard enums : "S.Arch.Quote"	
"S.Arch.Order"	
"P.Arch.Quote"	
"P.Arch.Order"	
"S.Arch.Return"	
"P.Arch.Return"
Using ACO_SpecialVendRepSelPurch as an exmplar, please fix similarly broken objects
Examine fixes I've made and make similar ones where necessary in the project
Fix object number issues, and continue applying the logic of my manual fixes to the project
Resolve all object number issues