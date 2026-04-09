### 0.2.4










* NSDate initWithTimeInterval:sinceDate now computes offsets correctly (fixes wrong-sign bug when creating dates relative to another date)
* NSCondition and NSConditionLock use platform thread helpers and absolute/monotonic-time retry logic to avoid premature timeouts and ensure proper unlocking
* NSLock lockBeforeDate now interprets deadlines consistently via timeIntervalSince1970
* Rename loader dependency symbols (MulleObjCLoader → MulleObjCDeps) and generated files to reflect dependency API
