/**
 * This header is generated by class-dump-z 0.2b.
 *
 * Source: /System/Library/PrivateFrameworks/ChatKit.framework/ChatKit
 */

#import <ChatKit/ChatKit-Structs.h>
#import <ChatKit/XXUnknownSuperclass.h>

@class FTCConnectionHandler;

@interface CKClientComposeServer : XXUnknownSuperclass {
@private
	xpc_connection_s *_connection;	// 4 = 0x4
	FTCConnectionHandler *_connectionHandler;	// 8 = 0x8
}
+ (id)sharedInstance;	// 0x82af5
- (id)init;	// 0x82a31
- (void)dealloc;	// 0x83551
- (void)start;	// 0x83541
- (void)stop;	// 0x83531
- (void)_startListeningForClientComposeNotifications;	// 0x834ed
- (void)_stopListeningForClientComposeNotifications;	// 0x834bd
- (void)_sendClientComposedMessage:(id)message markup:(id)markup subject:(id)subject recipients:(id)recipients attachmentPaths:(id)paths exportedFileNames:(id)names composeOptions:(id)options;	// 0x83389
- (void)_finishSendingClientComposedMessage:(id)message markup:(id)markup subject:(id)subject recipients:(id)recipients attachmentPaths:(id)paths exportedFileNames:(id)names composeOptions:(id)options;	// 0x82b21
@end
