## [Unreleased]

### New
- FDB.Transaction.set_versionstamped_key/4

### Breaking
- The return type of FDB.Transaction.get_versionstamp_q/1 changed from
  Future of type binary to FDB.Versionstamp.t