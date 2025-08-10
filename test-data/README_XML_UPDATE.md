# Exposure Import Test Data - XML Format

This folder contains both CSV and XML test files for testing the ACO_ExposureAutoImport report (Report 50912) functionality.

## Error Resolution

**Issue Encountered**: "Cannot import the specified XML document because the file is empty."

**Root Cause Analysis**: 
- XMLPort 50926 "ACO_ExposureImport" has Format = VariableText (CSV format)
- Job queue error indicates XML document processing expected
- Potential configuration mismatch between expected format and actual format

**Solution**: Created XML format files matching the XMLPort schema structure to resolve the "empty XML document" error.

## XML Test Files Overview

### 1. exposure_xml_001.xml - Basic XML Test
- **Purpose**: Header row + 5 customer records in XML format
- **Structure**: Full XML with root/DummyCustomer elements
- **Features**: 
  - Includes header row with "ACCOUNTREF" (should be skipped)
  - Basic customer numbers (CUST001-CUST005)
  - Various exposure amounts including zero

### 2. exposure_xml_002_no_header.xml - No Header XML Test  
- **Purpose**: Test file without header row in XML format
- **Structure**: 3 customer records (no header)
- **Features**:
  - Numeric customer IDs (10001, 10002, 10003)
  - All records should be processed (no "ACCOUNTREF" to skip)
  - Various exposure amounts

### 3. exposure_xml_003_detailed.xml - Comprehensive XML Test
- **Purpose**: Full 20-element test with realistic business data
- **Structure**: Header row + 3 detailed customer records  
- **Features**:
  - All 20 XML elements populated with meaningful data
  - Realistic company names and business information
  - Different currencies and regions
  - Business classification data

### 4. exposure_xml_004_edge_cases.xml - Error Handling XML Test
- **Purpose**: Test edge cases and error conditions in XML format
- **Structure**: Header row + 3 test records
- **Features**:
  - Invalid customer numbers (should be ignored)
  - Empty customer numbers (should be ignored)
  - Valid customer mixed with invalid ones

## XML Schema Structure

Based on XMLPort 50926 "ACO_ExposureImport" schema:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <DummyCustomer>
    <Column_CustomerNo>Customer Number</Column_CustomerNo>
    <Column2>Data Column 2</Column2>
    <!-- ... Columns 3-18 ... -->
    <Column_Exposure>Exposure Amount</Column_Exposure>
    <Column20>Optional Data</Column20>
  </DummyCustomer>
  <!-- Repeat DummyCustomer elements for each record -->
</root>
```

## Format Options Available

**CSV Format** (Original test files):
- exposure_test_001.csv through exposure_test_006_edge_cases.csv
- Format: VariableText (comma-separated values)
- Use when XMLPort Direction = Import, Format = VariableText

**XML Format** (New test files):
- exposure_xml_001.xml through exposure_xml_004_edge_cases.xml
- Format: XML structure matching XMLPort schema
- Use when job queue expects XML document processing

## Testing Instructions

**For XML Format Testing**:
1. Use the exposure_xml_*.xml files created to resolve the "empty XML document" error
2. Import via XMLPort 50926 with XML format support
3. Verify proper schema structure with root/DummyCustomer elements

**For CSV Format Testing**:
1. Use the original exposure_test_*.csv files if CSV format is correctly configured
2. Ensure XMLPort Format = VariableText configuration

## Expected Results

Both formats should achieve the same business results:
- Update ACO_Exposure field on existing Customer records
- Skip header rows containing "ACCOUNTREF"
- Allow zero exposure values
- Ignore invalid customer numbers

## Troubleshooting

**If "empty XML document" error persists**:
1. Verify file encoding (UTF-8)
2. Check XML structure matches XMLPort schema exactly
3. Ensure all required XML elements are present
4. Validate XML syntax with XML parser

**If CSV format preferred**:
1. Verify XMLPort Format = VariableText setting
2. Check job queue configuration for correct format expectation
3. Ensure file delimiter matches XMLPort configuration
