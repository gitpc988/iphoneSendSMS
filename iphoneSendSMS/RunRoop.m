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
    _tempGuid = 0;
    receive = @"";
    NSString *sendNumberID = @"";
    receive = [RequestSender sendRequest:@"http://210.72.13.8:8081/MsgServlet/msg"];
//    receive = @"13805761242^zjwlzx^9";
    if (receive.length >0  && [receive rangeOfString:@"^"].length>0) {
        aStr= [receive componentsSeparatedByString:@"^"];
        
        sendNumber = @"";
        sendContent = @"";
        sendNumber = [NSString stringWithFormat:@"%@",[aStr objectAtIndex:0]];
        sendContent = [NSString stringWithFormat:@"%@",[aStr objectAtIndex:1]];
        sendNumberID = [NSString stringWithFormat:@"%@",[aStr objectAtIndex:2]];            //如果更新成功  需要post 的id
        
//        sendNumber = @"471725371@qq.com";
//        sendContent = @"4717253711111";
//        sendNumberID = @"1";

        [self sendImessage:sendNumber sendContents:sendContent];
    }else{
        av = [[UIAlertView alloc] initWithTitle:@"iphoneSendSMS" message:@"未获取到数据,请重新打开程序" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        isEnable = false;
    }
  
    if (isEnable){
        [self performSelector:@selector(runAction:) withObject:sendNumberID afterDelay:10];
    }
}

-(void)unSelector{
    isEnable = false;
}

/*
 madrid_error    22         号码未开通imessage  发送失败
 madrid_error    4          打开飞行模式 发送失败
 madrid_error    39         关闭wifi 关闭3g 模式  发送失败
 
 madrid_error    0          成功
 
 madrid_flags    98309    成功
 madrid_flags    36869    成功(sent)
 madrid_flags    12289    成功
 
 madrid_flags    65541      发送失败
 madrid_flags    5          发送失败
 */

-(void)sendImessage:(NSString *)phoneNum sendContents:(NSString *)sendContents{
    
//    if (xf < 5) {
        NSString *value =[[UIDevice currentDevice] systemVersion];
        
        if([value hasPrefix:@"5"])
        {
            CKMadridService *imessageService = [CKMadridService sharedMadridService];
            CKConversationList *conversationList = nil;
            conversationList = [CKConversationList sharedConversationList];
            CKConversation *conversation;
            CKMessageComposition *ckMsgCom;
            CKMadridMessage *ckmMsg;
            CKMadridEntity *ckmEntity;
            ckmEntity = [imessageService copyEntityForAddressString:[NSString stringWithFormat:@"%@",phoneNum]];
                
            conversation = [conversationList conversationForRecipients:[NSArray arrayWithObject:ckmEntity] create:TRUE service:imessageService];
            ckMsgCom= [CKMessageComposition newCompositionForText:[NSString stringWithFormat:@"%@",sendContents]];
            ckmMsg= [imessageService newMessageWithComposition:ckMsgCom forConversation:conversation];
            [imessageService sendMessage:ckmMsg];
                
//            [conversationList removeConversation:conversation];
            _tempGuid = [ckmMsg guid];
//            av1 = [[UIAlertView alloc] initWithTitle:@"iphoneSendSMS" message:[NSString stringWithFormat:@"%d",[conversation groupID]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [av1 show];

        }
//        xf ++;
        
//    }else{
//        [self performSelector:@selector(runAction) withObject:self afterDelay:2];

//    }
    
      
}
-(void)runAction:(NSString *)phoneNumberID{
    NSString *isSuc=@"1";
    
    isSuc  = [self getMadridError];
    
    if ([isSuc intValue] == 0) {        //发送成功
       NSString *tempStr = [RequestSender sendRequest:[NSString stringWithFormat:@"http://210.72.13.8:8081/MsgServlet/updateMsg?id=%@",phoneNumberID]];
    }
    
    if (isEnable){
        [self performSelector:@selector(deletesms) withObject:self afterDelay:3];
    }
    
}
-(NSString *)getMadridError{
    NSString *flags;
     NSString *alertStr = @"";
	sqlite3 *database;
	if(sqlite3_open([@"/private/var/mobile/Library/SMS/sms.db" UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *addStatement;
                
        NSString *querySql = [NSString stringWithFormat:@"select madrid_error FROM message where madrid_guid = '%@'",_tempGuid];

        const char *sql5 = [querySql UTF8String];
        
        alertStr = [NSString stringWithFormat:@"querySql=%@",querySql];
        char *text1;
        NSString *value =[[UIDevice currentDevice] systemVersion];
        if([value hasPrefix:@"5"])
        {
            sqlite3_prepare_v2(database, sql5, -1, &addStatement, NULL);
            
            
            
            while(sqlite3_step(addStatement) == SQLITE_ROW) {
                
                
                text1 = (char *)sqlite3_column_text(addStatement, 0);
                alertStr = [NSString stringWithFormat:@"%s",text1];
                if (text1 != nil) {
                    
                    flags = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(addStatement, 1)];
                    
//                    alertStr = [NSString stringWithFormat:@"%@=flags=%@",alertStr,flags];
                }else{
                    
                }
            }
        }
        
    }
//    sqlite3_close(database);
    
    return alertStr;
}

-(void)deletesms{
   NSString *temp = [self DeleteSMS:@"11"];
//    av = [[UIAlertView alloc] initWithTitle:@"iphoneSendSMS" message:temp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [av show];

    if (isEnable){
    [self performSelector:@selector(callBack) withObject:self afterDelay:5];
    }
}

-(void)callBack{
    [self mainMethod];
}


#pragma mark use sqlite access database
//  NSString *querySql = [NSString stringWithFormat:@"drop trigger delete_message;delete from message where madrid_guid = '%@';CREATE TRIGGER delete_message AFTER DELETE ON message WHEN NOT read(old.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = old.group_id) - 1 WHERE ROWID = old.group_id; END",_tempGuid];

//[NSString stringWithFormat:@"drop trigger insert_newest_message;drop trigger insert_unread_message;delete from message where madrid_guid = '%@';CREATE TRIGGER insert_unread_message AFTER INSERT ON message WHEN NOT read(new.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) + 1 WHERE ROWID = new.group_id;CREATE TRIGGER delete_newest_message AFTER DELETE ON message WHEN old.ROWID = (SELECT newest_message FROM msg_group WHERE ROWID = old.group_id) BEGIN UPDATE msg_group SET newest_message = (SELECT ROWID FROM message WHERE group_id = old.group_id AND ROWID = (SELECT max(ROWID) FROM message WHERE group_id = old.group_id)) WHERE ROWID = old.group_id",_tempGuid];

//@"drop trigger delete_message;drop trigger mark_message_read;drop trigger mark_message_unread; drop trigger insert_newest_message;drop trigger insert_unread_message;drop trigger delete_newest_message;delete from message where madrid_guid = '%@';CREATE TRIGGER delete_message AFTER DELETE ON message WHEN NOT read(old.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = old.group_id) - 1 WHERE ROWID = old.group_id; END"

/*
 执行以下查询语句跳过触发器调用的read函数.欺骗一下数据库。
 
 drop trigger insert_unread_message;
 drop trigger mark_message_unread;
 drop trigger mark_message_read;
 drop trigger delete_message;
 CREATE TRIGGER insert_unread_message AFTER INSERT ON message WHEN NOT new.flags = 2 BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) + 1 WHERE ROWID = new.group_id; END;
 CREATE TRIGGER mark_message_unread AFTER UPDATE ON message WHEN old.flags = 2 AND NOT new.flags = 2 BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) + 1 WHERE ROWID = new.group_id; END;
 CREATE TRIGGER mark_message_read AFTER UPDATE ON message WHEN NOT old.flags = 2 AND new.flags = 2 BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) - 1 WHERE ROWID = new.group_id; END;
 CREATE TRIGGER delete_message AFTER DELETE ON message WHEN NOT old.flags = 2 BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = old.group_id) - 1 WHERE ROWID = old.group_id; END;
 
 就可以进行删除。
 
 delete from message where xxxx
 然后设置所有短信为已读
 
 update msg_group set unread_count = 0
 顺便整理一下
 
 VACUUM;
 还原触发器
 
 drop trigger insert_unread_message;
 drop trigger mark_message_unread;
 drop trigger mark_message_read;
 drop trigger delete_message;
 
 CREATE TRIGGER delete_message AFTER DELETE ON message WHEN NOT read(old.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = old.group_id) - 1 WHERE ROWID = old.group_id; END;
 CREATE TRIGGER insert_unread_message AFTER INSERT ON message WHEN NOT read(new.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) + 1 WHERE ROWID = new.group_id; END;
 CREATE TRIGGER mark_message_read AFTER UPDATE ON message WHEN NOT read(old.flags) AND read(new.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) - 1 WHERE ROWID = new.group_id; END;
 CREATE TRIGGER mark_message_unread AFTER UPDATE ON message WHEN read(old.flags) AND NOT read(new.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = new.group_id) + 1 WHERE ROWID = new.group_id; END;

 */
//int callB(void* para,int n_colum,char **column_value,char **columaName){
//    [(RunRoop *)para ccx:n_colum];
//    return 0;
//}

//-(void)ccx:(int)x{
//    av1 = [[UIAlertView alloc] initWithTitle:@"iphoneSendSMS" message:@"cccc" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [av1 show];
//    return 0;
//}

-(NSString *)DeleteSMS:(NSString *)grp {
	NSLog(@"Deleting SMS for group: %@", grp);
	
	BOOL done = NO;
    char *errmsg = NULL;
	//insert into msg_group
	sqlite3 *database;
    
	if(sqlite3_open([@"/private/var/mobile/Library/SMS/sms.db" UTF8String], &database) == SQLITE_OK) {
        NSString *sqlDelStr  = [NSString stringWithFormat:@"drop trigger delete_message;delete from message where madrid_guid = '%@';delete from madrid_chat;CREATE TRIGGER delete_message AFTER DELETE ON message WHEN NOT read(old.flags) BEGIN UPDATE msg_group SET unread_count = (SELECT unread_count FROM msg_group WHERE ROWID = old.group_id) - 1 WHERE ROWID = old.group_id; END",_tempGuid];
		const char *sqlnewgrp = [sqlDelStr UTF8String];
		
        if (sqlite3_exec(database, sqlnewgrp,NULL, NULL, &errmsg) == SQLITE_OK) {
            done = YES;
        }
	}
	
//	sqlite3_close(database);
	
	if (done) {
		return @"Deleted";
	} else {
		return [NSString stringWithFormat:@"Error while deleting:%s", sqlite3_errmsg(database)];
	}
	
}

-(void)dealloc{
    [av1 release];
    [av release];
    [super dealloc];
}
@end

@implementation RequestSender
            
+ (NSString*)sendRequest:(NSString*)url
{
    
    //准备发送httprequest
    
    NSString *urlString = url;
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"GET"];
    
    //设置http头
    
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //创建http内容
    
    //NSMutableData *postBody = [NSMutableData data];
    
    //[postBody appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[postBody appendData:[[NSString stringWithFormat:@""]
    
    //dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[postBody appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置发送内容
    
    //[request setHTTPBody:postBody];
    
    //获取响应
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSError *error = [[[NSError alloc] init] autorelease];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *result = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
    //返回的http状态
    
    NSLog(@"Response Code: %d", [urlResponse statusCode]);
    
    //获取返回的内容
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
        
    {
        
        NSLog(@"Response: %@", result);
        
        return result;
        
        //执行你想要的内容，代码可以写在这里
        
    }
    
    return @"";
    
}


@end