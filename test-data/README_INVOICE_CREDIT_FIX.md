# Invoice and Credit Import Test Data

## Test Files Created for Auto Import Testing

### Invoice Test Files:
- `test_invoice_001.csv` - Basic invoice test data with 3 customer records
  - Contains standard 20-column format required by XMLPort ACO_InvoiceImport
  - Customer numbers: C001, C002, C003
  - Document numbers: INV-2024-001 through INV-2024-003
  - Products, quantities, and pricing included

### Credit Test Files:
- `test_credit_001.csv` - Basic credit memo test data with 3 customer records
  - Contains standard 20-column format required by XMLPort ACO_CreditImport
  - Customer numbers: C001, C002, C003
  - Document numbers: CM-2024-001 through CM-2024-003
  - Credit amounts and adjustments included

## Usage Instructions:

1. **For Auto Import Testing**: Copy files to configured import directories:
   - Invoice files → ACO_InvoiceFileSource directory
   - Credit files → ACO_CreditFileSource directory

2. **For Manual Import Testing**: Use test actions on Additional Setup page

3. **Expected Behavior**: 
   - Files should process completely without "empty XML document" errors
   - Data should import into ACO_ImportLog for processing
   - Files should move to archive directories after successful processing

## Technical Details:

- **Format**: 20-column CSV format matching XMLPort schema
- **XMLPorts**: ACO_InvoiceImport (Invoice), ACO_CreditImport (Credit)
- **Processing**: VariableText format (CSV) via XMLPort with TempBlob loading

## Fix Applied:

The "Cannot import the specified XML document because the file is empty" error has been resolved by adding missing file loading steps in:
- ImportQuantumInvoiceFile() method
- ImportQuantumCreditFile() method

Both methods now properly load file data into TempBlob before processing.
