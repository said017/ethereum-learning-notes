# Manual Review

**Different Approaches :**

- Access Control
  - Fundamental security primitive
  - Who has access to what? actors → assets
  - Roles : Admins/Users , visibility/modifiers
  - Correct & Complete & Consistent
- Asset Flow
  - Assets ETH or ERC20/ERC721 tokens
  - Who/when/which
  - Why (reason) /Where (only to specified address)
  - What Type/How Much
- Control Flow
  - Transfer of Control : Execution Order
  - Intra/Inter Procedural
  - Conditional & Loops
  - Control Flow Graph
- Data Flow
  - Transfer of Data : Execution Context
  - Variables & Constants
  - Function arguments & return values
  - Storage/Memory/Stack/Calldata

**Different Focus:**

- Inferring Constraints
  - Program Constrains → Rules/properties
  - Solidity/EVM vs Application Constrains (Rules specific to business logic)
  - Lack of spec / documentation
  - Maximal Occurrence → Inference
- Dependencies
  - External code/data
  - Libraries/Protocols/Oracles
  - Composability (Multiple smart contracts)
  - Assumptions on functionality/correctness
- Assumptions
  - Who/What/When/Why etc.
  - Verify assumptions
  - E.g. : Only admins, initialization only once, orders of call, return values, input validation.
  - State Analysis
- Checklist
  - Itemized Lists
  - Retention & Recall
  - Pitfalls & Best Practices
  - No Missed Checks

**Exploit Scenarios :**

- Proof-of-Concept
- Written Descriptions / code
- Reasonable & Responsible
- Realistic & Relatable

****************\*\*****************Likelihood & Impact :****************\*\*****************

- Likelihood : Probability & difficulty
- Impact : Magnitude of Implications
- Severity Likelihood + Impact
- Access & Assumptions , funds vs functioning

************\*\*************Audit Summary************\*\*************

- Bounded Effort , Time, resources, expertise
- Automated vs Manual
- Findings : difficulty/impact/severity
- Show presence but not absence
