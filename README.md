

# STX-DocuSure Document Verification Smart Contract

A secure and enhanced smart contract for registering, managing, and verifying digital documents on the Stacks blockchain. It supports permissioned access control, versioning, and auditability.

---

## 🚀 Features

- ✅ Register new documents with metadata and content hash
- 📝 Modify existing documents before verification
- 🔐 Assign and remove permissions for viewing and verification
- 🕵️ Verify documents with access control
- 📚 Retrieve document details and permission info
- 🔄 Version control with incremental tracking
- ⚠️ Robust error handling and input validation

---

## 🧱 Smart Contract Overview

### ✅ Constants

- **Verification Status**:
  - `STATUS-PENDING` – Initial status for submitted documents
  - `STATUS-VERIFIED` – Status for successfully verified documents

- **Error Codes**: Ensures traceable errors such as:
  - `ERR-UNAUTHORIZED-ACCESS`
  - `ERR-DUPLICATE-DOCUMENT`
  - `ERR-DOCUMENT-MISSING`
  - `ERR-INVALID-INPUT`, and more

---

## 🗃️ Data Structures

### 📌 `document-records`

Stores each document with:
- `document-owner`: `principal`
- `document-content-hash`: `(buff 32)`
- `submission-timestamp`: `uint`
- `verification-status`: `(string-ascii 20)`
- `verification-authority`: `(optional principal)`
- `document-metadata`: `(string-utf8 256)`
- `document-version`: `uint`
- `verification-complete`: `bool`

### 👥 `document-permissions`

Defines access rights:
- `document-viewing-permission`: `bool`
- `document-verification-permission`: `bool`

---

## 🔐 Validation Helpers

- `check-buff-32`: Validates 32-byte buffers
- `check-string-utf8`: Ensures non-empty valid UTF-8 strings (≤ 256 bytes)
- `check-principal`: Ensures a different principal than `tx-sender` or contract itself
- `validate-and-sanitize-*`: Wraps above helpers with `ok/err` response types

---

## 📖 Read-Only Functions

### `get-document-details (document-hash-id)`
Returns document record for the given hash ID.

### `get-user-permissions (document-hash-id, authorized-user)`
Returns permission status for a user on a specific document.

---

## 🔧 Public Functions

### `register-new-document (document-hash-id, document-content-hash, document-metadata)`
- Registers a new document
- Only one document per unique `document-hash-id` is allowed

### `modify-existing-document (document-hash-id, updated-content-hash, updated-metadata)`
- Only the document owner can modify
- Modifiable **only before** verification is complete

### `perform-document-verification (document-hash-id)`
- Requires `document-verification-permission`
- Verifies a document, sets `verification-authority`, and marks it complete

### `assign-document-permissions (document-hash-id, authorized-user, grant-viewing-permission, grant-verification-permission)`
- Assigns permissions to another user
- Only the document owner can assign

### `remove-document-permissions (document-hash-id, authorized-user)`
- Removes permissions for a user
- Only the document owner can remove

---

## 📦 Example Workflow

1. **Register a Document**
```lisp
(register-new-document 
  0xABC123... 
  0xHASH123... 
  "Birth Certificate - Alice Doe")
```

2. **Assign Permissions**
```lisp
(assign-document-permissions 
  0xABC123... 
  'SP123XYZ... 
  true 
  true)
```

3. **Perform Verification**
```lisp
(perform-document-verification 
  0xABC123...)
```

---

## ❗Security & Best Practices

- Only the document owner can modify or assign permissions
- Verification is **final**; post-verification edits are blocked
- Input validation guards against malformed or malicious data

---

## 📜 Requirements

- **Stacks Blockchain** with Clarity support
- **Clarity 2.0 Compatible** environment (e.g., [Clarinet](https://docs.hiro.so/clarinet))

---

## 🧪 Testing

Use Clarinet to write tests that simulate:
- Document registration/modification
- Permission assignment and enforcement
- Verification scenarios and error handling

---

## 🧠 Future Improvements

- Event logging for auditing
- Document expiration/revocation
- Role-based permission models
- Integration with IPFS or off-chain storage

---

## 🤝 Contributing

Feel free to fork, suggest improvements, or raise issues. Let's build secure and verifiable record systems together!

---
