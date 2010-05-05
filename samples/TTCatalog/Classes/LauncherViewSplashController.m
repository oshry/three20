//
//  LauncherViewSplashController.m
//  TTCatalog
//
//  Created by Rodrigo Mazzilli on 10/7/09.
//

#import "LauncherViewSplashController.h"


@implementation LauncherViewSplashController

- (void)loadView {
	[super loadView];
	
	_launcherView.delegate = self;
	_launcherView.columnCount = 4;
	_launcherView.pages = [NSArray arrayWithObjects:
						   [NSArray arrayWithObjects:
							[[[TTLauncherItem alloc] initWithTitle:@"Search Test"
															 image:@"bundle://Icon.png"
															   URL:@"tt://searchTest" canDelete:YES] autorelease],
							[[[TTLauncherItem alloc] initWithTitle:@"Photo Test"
															 image:@"bundle://Icon.png"
															   URL:@"tt://photoTest1" canDelete:YES] autorelease],
							[[[TTLauncherItem alloc] initWithTitle:@"Table Item"
															 image:@"bundle://Icon.png"
															   URL:@"tt://tableItemTest" canDelete:YES] autorelease],
							nil], 
						   nil
						   ];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	TTURLAction *action = [TTURLAction actionWithURLPath:item.URL];
	[action setAnimated:YES];
	[[TTNavigator navigator] openURLAction:action];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] 
												 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

@end
