//
//  TTLauncherViewController.h
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.

#import "Three20/TTView.h"
#import "Three20/TTViewController.h"
#import "Three20/TTLauncherView.h"


@interface TTLauncherViewController : TTViewController <UINavigationControllerDelegate> {
	UIView *_overlayView;
	TTView *_headerView;
	TTView *_footerView;
	TTLauncherView *_launcherView;
	UINavigationController *_launcherNavigationController;
	UIViewController *_launcherNavigationControllerTopViewController;
}
- (void)dismissChild;
- (void)dismissChildAnimated:(BOOL)animated;

@property(nonatomic, retain) UINavigationController *launcherNavigationController;
@property(nonatomic, readonly) TTLauncherView *launcherView;
@property(nonatomic, retain) UIViewController *launcherNavigationControllerTopViewController;
@property(nonatomic, retain) UIView *headerView;
@property(nonatomic, retain) UIView *footerView;

@end
