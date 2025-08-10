# Exposure Import Test Data

This folder contains CSV test files for testing the ACO_ExposureAutoImport report (Report 50912) functionality.

## Test Files Overview

### 1. exposure_test_001.csv - Basic Test
- **Purpose**: Simple test with minimal data
- **Structure**: Header row + 5 customer records
- **Features**: 
  - Includes header row with "ACCOUNTREF" (should be skipped)
  - Basic customer numbers (CUST001-CUST005)
  - Various exposure amounts including zero

### 2. exposure_test_002.csv - Enhanced Test  
- **Purpose**: More realistic data with additional columns populated
- **Structure**: Header row + 6 customer records
- **Features**:
  - Descriptive headers
  - Sample data in various columns
  - Mix of currencies (GBP, USD, EUR)
  - Includes inactive customer test

### 3. exposure_test_003_no_header.csv - No Header Test
- **Purpose**: Test file without header row
- **Structure**: 7 customer records (no header)
- **Features**:
  - Numeric customer IDs (10001, 10002, etc.)
  - All records should be processed (no "ACCOUNTREF" to skip)
  - Various exposure amounts

### 4. exposure_test_004_detailed.csv - Comprehensive Test
- **Purpose**: Full 20-column test with realistic business data
- **Structure**: Header row + 5 detailed customer records  
- **Features**:
  - All 20 columns populated with meaningful data
  - Realistic company names and business information
  - Different currencies and regions
  - Business classification data

### 5. exposure_test_005_zero_exposure.csv - Zero Values Test
- **Purpose**: Test importing zero exposure values
- **Structure**: Header row + 5 records with zero exposure
- **Features**:
  - All exposure values set to 0.00
  - Tests the comment in code: "FIX to allow import 0"

### 6. exposure_test_006_edge_cases.csv - Error Handling Test
- **Purpose**: Test edge cases and error conditions
- **Structure**: Header row + 4 test records
- **Features**:
  - Invalid customer numbers (should be ignored)
  - Empty customer numbers (should be ignored)
  - Valid customer mixed with invalid ones
  - Negative exposure value test

## File Format Requirements

Based on analysis of ACO_ExposureImport XMLPort (ID: 50926):

- **Format**: CSV (VariableText)
- **Columns**: 20 total columns
  - Column 1: Customer Number
  - Columns 2-18: Additional data (not processed)
  - Column 19: Exposure amount (decimal)
  - Column 20: Optional additional data
- **Header Handling**: Rows containing "ACCOUNTREF" in Column 1 are skipped
- **Processing Logic**: 
  - Only updates existing Customer records
  - Validates customer number and exposure amount
  - Allows zero values
  - Updates ACO_Exposure field on Customer table

## Testing Instructions

1. **Prerequisites**: 
   - Ensure test customers exist in the system (CUST001-CUST006, 10001-30002, C001-C005, etc.)
   - Configure ACO_AdditionalSetup with appropriate file source path

2. **Manual Testing**:
   - Use Report 50916 "ACO_ExposureImport" for manual file selection
   - Run XMLPort 50926 "ACO_ExposureImport" directly

3. **Automated Testing**:
   - Copy test files to the configured ACO_ExposureFileSource directory
   - Run Report 50912 "ACO_ExposureAutoImport"
   - Files will be automatically processed and moved to ACO_ExposureFileProcessed directory

4. **Verification**:
   - Check Customer records for updated ACO_Exposure values
   - Verify files are moved to processed directory with timestamp prefix
   - Check for any error messages or processing logs

## Expected Results

- **exposure_test_001.csv**: 5 customers updated with specified exposure amounts
- **exposure_test_002.csv**: 6 customers updated (including inactive customer)  
- **exposure_test_003_no_header.csv**: 7 customers updated (all records processed)
- **exposure_test_004_detailed.csv**: 5 customers updated with large exposure amounts
- **exposure_test_005_zero_exposure.csv**: 5 customers updated with zero exposure
- **exposure_test_006_edge_cases.csv**: Only CUST999 should be updated; invalid records ignored

## Notes

- The XMLPort uses text encoding specified in ACO_AdditionalSetup.ACO_XMLPortTextEnconding
- Processing preserves existing customer data; only ACO_Exposure field is updated
- Invalid customer numbers are silently ignored (no error raised)
- File archiving includes timestamp prefix in format: YYYYMMDD_HHMM_filename.csv
