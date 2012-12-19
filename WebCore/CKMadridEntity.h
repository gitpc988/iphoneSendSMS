/* Generated by RuntimeBrowser.
   Image: /System/Library/PrivateFrameworks/ChatKit.framework/ChatKit
 */

@class NSArray;

@interface CKMadridEntity : CKEntity  {
    NSArray *_imHandles;
    BOOL _shared;
}

+ (id)_sharedMadridEntities;
+ (void)resetAllSharedEntityCaches;
+ (id)copyAllEntities;

- (int)propertyType;
- (int)identifier;
- (id)name;
- (id)_existingEntityFromSharedForIMHandle:(id)arg1;
- (void)_setOtherIMHandlesForIMHandle:(id)arg1;
- (void)_addToShared;
- (void)_removeFromShared;
- (void)_resetIMHandles;
- (id)imHandles;
- (id)defaultIMHandle;
- (id)initWithIMHandle:(id)arg1;
- (void)_handleActiveMadridAccountsDidChange:(id)arg1;
- (struct __CFPhoneNumber { }*)phoneNumberRef;
- (void*)abRecord;
- (id)rawAddress;
- (BOOL)isEqual:(id)arg1;
- (unsigned int)hash;
- (id)description;
- (void)dealloc;

@end
