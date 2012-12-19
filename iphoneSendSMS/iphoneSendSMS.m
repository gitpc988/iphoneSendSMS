//
//  iphoneSendSMS.m
//  iphoneSendSMS
//
//  Created by lin bo on 12-11-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// SBSettings by BigBoss
// see http://thebigboss.org/guides-iphone-ipod-ipad/sbsettings-toggle-spec

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ChatKit/CKSMSService.h>
#import <ChatKit/CKConversationList.h>
#import <ChatKit/CKSMSEntity.h>
#import <ChatKit/CKConversation.h>
#import <ChatKit/CKSMSMessage.h>

#import <ChatKit/CKMessageComposition.h>
#import "CKMadridService.h"
#import "CKMadridEntity.h"
#import "CKMadridMessage.h"

#import "RunRoop.h"
//#import <CoreTelephony/CTMessage.h>
//#import <CoreTelephony/CTMessagePart.h>

#include <notify.h>



static BOOL isToggleEnabled;
static RunRoop *r;

BOOL isCapable() // required; called when loaded; indicates if toggle supports current platform
{
	return YES;
}

BOOL isEnabled() // required; called when refresh button is pressed; functionally determines and indicates if toggle is on
{
	// perform something here to functionally determine if toggle is on and set isToggleEnabled accordingly
	// ...
	
	return isToggleEnabled;
}

BOOL getStateFast() // optional; called each time SBSettings window is shown; quickly indicates if toggle is on
{
	// nothing is performed to functionally determine if toggle is on, only return last known state using isToggleEnabled (for performance reasons)
	return isToggleEnabled;
}

void setContainer(int container) // optional; called when loaded, before closeWindow and before setState
{
	if (container == 0) // SBSettings window
	{
		
	}
	else if (container == 1) // Notification Center
	{
		
	}
}

void setState(BOOL enable) // required; called when user presses toggle button
{
	if (enable) // toggle is disabled, so enable it
	{
        
        r= [[RunRoop alloc] init];
        [r mainMethod];
            
	}
	else // toggle is enabled, so disable it
	{
        [r unSelector];
        [r release];
//		av = [[UIAlertView alloc] initWithTitle:@"iphoneSendSMS" message:@"Toggle Disabled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	}

//	[av show];
	isToggleEnabled = enable; // for getStateFast() use
}



float getDelayTime() // required; time in seconds spinner will show on toggle button after setState() returns (to allow background work to perform)
{
	return 0.0f;
}

BOOL allowInCall() // optional, if not implemented, assumed to return YES; indicates if toggle can be used during a call
{
	return YES;
}

void invokeHoldAction() // optional; called when user holds toggle button down (allowing handling of such event)
{	
	// since toggle runs as the mobile user, to run an executable or script as root user, use notify_post() to notify sbsettingsd. the notification message must be the executable or script name that will be located in /var/mobile/Library/SBSettings/Commands. see link above for more information.
	//notify_post("com.company.iphoneSendSMS-ExampleCommand");
}

void closeWindow() // optional; called before SBSettings window closes
{
	
}
