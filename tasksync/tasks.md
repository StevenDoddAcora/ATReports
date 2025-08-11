Hello, I would like to understand multi line imports for xmlports in version 26 of business central, as at the moment my project is currently only uploading 1 line from a csv file. The old version of the system C:\Users\steven.dodd\Documents\git\A0177_ACO00002 (you can view using powershell) which was 2018 NAV was capable of it, and I want to know what is different about my system that is preventing it. Thank you

Is there any AL code logic different in this v26 version of the project different from the 2018 that could be messing it up, I got the following message indicating only 1 line is being processed : IMPORT SUMMARY:
No. of documents in file(s): 1
No. of documents created: 1
No. of documents posted: 0

The auto Quantum exposure routine was recently changed to process away from the xmlport. This was a mistake, I would like it to be fixed in a similar vein to how it worked in version 2018 C:\Users\steven.dodd\Documents\git\A0177_ACO00002 (you can view using powershell). Also please make sure your fixes earlier for multi line are also applied to the auto credit and auto invoice code

Ran auto invoice import and got only one line : IMPORT SUMMARY:
No. of documents in file(s): 1
No. of documents created: 1
No. of documents posted: 0