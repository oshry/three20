//
//  TTLauncherViewController.h
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.
//  Copyright 2009 wellknown.as Inc.. All rights reserved.
//

#import "Three20/TTViewController.h"
#import "Three20/TTLauncherView.h"

@interface TTLauncherViewController : TTViewController {
	UIView *_overlayView;
	TTLauncherView *_launcherView;
	UINavigationController *_launcherNavigationController;
}
@property(nonatomic, retain) UINavigationController *launcherNavigationController;

@end
