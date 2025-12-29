# Review T3: Business Interfaces

**Review Date**: 2025-12-29
**Reviewer**: Antigravity
**Status**: 🟡 APPROVED WITH MODIFICATIONS

## Summary
The interface definitions for Repositories and Services provide a solid foundation for Clean Architecture. The use of abstract classes decouples the logic layer from SQL and Encryption implementation details. However, one critical performance requirement from the Constitution is currently unaddressed in the interface contracts.

## Key Findings

### 1. Missing Streaming Support (Performance & OOM Risk)
- **Violation**: `ICryptoService` currently only defines `Uint8List` (memory-based) encryption/decryption.
- **Constitution Reference**: `Constitution#Technology Stack#File Encryption` specifies: "Large files must use streaming encryption to avoid OOM."
- **Risk**: Encrypting 10MB+ medical images entirely in memory will cause application crashes on lower-end devices.
- **Action**: Add streaming methods to `ICryptoService` or a specialized `IFileSecurityService`.
    - *Example*: `Future<void> encryptFile(String inputPath, String outputPath, Uint8List key)`.

### 2. Batch Operations for Images
- **Observation**: `IImageRepository` should be reviewed to ensure it supports batch saving.
- **Reasoning**: A single clinical visit often results in 5-10 images. Sequential individual saves are less efficient than a single transaction-backed batch save.
- **Action**: Ensure `saveImages(List<MedicalImage> images)` is present in the contract.

### 3. Error Handling Standardization
- **Observation**: `SecurityException` is a good start. 
- **Recommendation**: Consider defining a base `DomainException` to standardize how Repositories report database or file system failures to the UI/ViewModel layer.

## Architectural Alignment
- **Domain Decoupling**: 🟢 Pass. Interfaces do not leak SQLCipher or AES implementation specifics.
- **Naming Conventions**: 🟢 Pass. Follows standard `I[Name]` prefixing or clean abstract naming.

---

**Next Steps**:
1. Update `lib/logic/services/interfaces/crypto_service.dart` to include file-based or stream-based encryption methods.
2. Verify `IImageRepository` supports batch operations to handle multi-image ingestion efficiently.