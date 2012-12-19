//
//  RunRoop.h
//  iphoneSendSMS
//
//  Created by lin bo on 12-11-30.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RunRoop : NSObject{
    UIAlertView *av,*av1;
    id _tempGuid;
    NSString *receive;
    NSArray *aStr;
    
    NSString *sendNumber;
    NSString *sendContent;
    
    int xf;
    int xx;
    
    bool isEnable;
    
}
-(void)mainMethod;
-(void)unSelector;
@property(nonatomic,assign) id tempGuid;

@end


@interface RequestSender : NSObject {
    
}

+ (NSString*)sendRequest:(NSString*)url;

@end