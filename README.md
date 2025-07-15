# Decentralized Vendor Management Contract Lifecycle System

A comprehensive blockchain-based system for managing vendor contracts throughout their entire lifecycle, built on the Stacks blockchain using Clarity smart contracts.

## System Overview

This system consists of five interconnected smart contracts that handle different aspects of vendor contract management:

1. **Contract Administrator Verification** (`contract-admin-verification.clar`)
    - Validates and manages contract administrators
    - Handles administrator registration and verification
    - Maintains administrator permissions and roles

2. **Contract Creation** (`contract-creation.clar`)
    - Creates new vendor contracts
    - Defines contract terms and conditions
    - Manages initial contract setup and validation

3. **Amendment Tracking** (`amendment-tracking.clar`)
    - Tracks all contract amendments and modifications
    - Maintains amendment history and approval workflow
    - Ensures amendment compliance and validation

4. **Performance Monitoring** (`performance-monitoring.clar`)
    - Monitors contract performance metrics
    - Tracks deliverables and milestones
    - Manages performance scoring and evaluation

5. **Renewal Management** (`renewal-management.clar`)
    - Handles contract renewal processes
    - Manages renewal terms and negotiations
    - Automates renewal workflows and notifications

## Key Features

- **Decentralized Governance**: No single point of control
- **Transparent Operations**: All actions recorded on blockchain
- **Automated Workflows**: Smart contract automation for routine tasks
- **Audit Trail**: Complete history of all contract activities
- **Role-Based Access**: Different permission levels for different users
- **Performance Tracking**: Built-in metrics and scoring system

## Contract Architecture

### Data Structures

Each contract uses optimized data structures for efficient storage and retrieval:
- Maps for key-value relationships
- Variables for global state management
- Constants for system parameters

### Error Handling

Comprehensive error handling with specific error codes:
- Input validation errors
- Permission errors
- State transition errors
- Business logic errors

### Security Features

- Administrator verification requirements
- Input validation and sanitization
- State consistency checks
- Access control mechanisms

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js and npm for testing
- Basic understanding of Clarity smart contracts

### Installation

1. Clone the repository
2. Install dependencies: `npm install`
3. Run tests: `npm test`
4. Deploy contracts using Clarinet

### Testing

The system includes comprehensive tests using Vitest:
- Unit tests for individual contract functions
- Integration tests for cross-contract workflows
- Edge case testing for error conditions

### Usage Examples

#### Registering an Administrator
\`\`\`clarity
(contract-call? .contract-admin-verification register-admin tx-sender "John Doe" "Senior Contract Manager")
\`\`\`

#### Creating a New Contract
\`\`\`clarity
(contract-call? .contract-creation create-contract "Vendor ABC" "Software Development" u1000000 u365)
\`\`\`

#### Adding an Amendment
\`\`\`clarity
(contract-call? .amendment-tracking add-amendment u1 "Updated delivery timeline" "Extended deadline by 30 days")
\`\`\`

## Contract Specifications

### Administrator Verification Contract
- Manages administrator registration and verification
- Maintains administrator profiles and permissions
- Handles role assignments and updates

### Contract Creation Contract
- Creates new vendor contracts with specified terms
- Validates contract parameters and requirements
- Manages contract initialization and setup

### Amendment Tracking Contract
- Records all contract amendments and changes
- Maintains amendment approval workflow
- Provides amendment history and audit trail

### Performance Monitoring Contract
- Tracks contract performance metrics and KPIs
- Manages milestone tracking and completion
- Calculates performance scores and ratings

### Renewal Management Contract
- Handles contract renewal processes and workflows
- Manages renewal terms and negotiations
- Automates renewal notifications and reminders

## API Reference

Each contract exposes public functions for interaction:
- Read-only functions for data retrieval
- State-changing functions for updates
- Administrative functions for management

## Security Considerations

- All functions include proper access control
- Input validation prevents malicious data
- State consistency maintained across operations
- Administrator verification required for sensitive operations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License.
