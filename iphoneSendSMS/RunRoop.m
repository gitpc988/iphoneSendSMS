//
//  RunRoop.m
//  iphoneSendSMS
//
//  Created by lin bo on 12-11-30.
//
//

#import "RunRoop.h"
#import <sqlite3.h>

#import <ChatKit/CKSMSService.h>
#import <ChatKit/CKConversationList.h>
#import <ChatKit/CKSMSEntity.h>
#import <ChatKit/CKConversation.h>
#import <ChatKit/CKSMSMessage.h>

#import <ChatKit/CKMessageComposition.h>
#import "CKMadridService.h"
#import "CKMadridEntity.h"
#import "CKMadridMessage.h"

@implementation RunRoop
@synthesize tempGuid = _tempGuid;
-(id)init{
    if (self = [super init]) {
        isEnable = true;
    }
    return self;
}
-(void)mainMethod{
   
}

-(void)unSelector{
    isEnable = false;
}


@end
