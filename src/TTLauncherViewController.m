//
//  TTLauncherViewController.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.


#import "Three20/TTLauncherViewController.h"
#import "Three20/TTDefaultStyleSheet.h"
#import "Three20/TTURLCache.h"

@interface TTLauncherViewController (Private)
- (void)dismissChildAnimated:(BOOL)animated;
@end


@implementation TTLauncherViewController

@synthesize launcherNavigationController = _launcherNavigationController;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_overlayView);
	TT_RELEASE_SAFELY(_launcherView);
	TT_RELEASE_SAFELY(_launcherNavigationController);
    [super dealloc];
}

- (id)init {
	if (self = [super init]) {
		_launcherNavigationController = nil;
		_overlayView = nil;
	}
	return self;
}

- (void)loadView {
	[super loadView];
	_launcherView = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
	_launcherView.backgroundColor = TTSTYLEVAR(launcherBackgroundColor);
	self.view = _launcherView;
	
}

- (CGAffineTransform)transformForOrientation {
	return TTRotateTransformForOrientation(TTInterfaceOrientation());
}

#pragma mark -
#pragma mark Overlay view

- (CGRect)rectForOverlayView {
	return [_launcherView frameWithKeyboardSubtracted:0];
}

- (void)addOverlayView {
	if (!_overlayView) {
		CGRect frame = [self rectForOverlayView];
		_overlayView = [[UIView alloc] initWithFrame:frame];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.alpha = 0.0f;
		_overlayView.autoresizesSubviews = YES;
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[_launcherView addSubview:_overlayView];
	}
	self.view.frame = _overlayView.bounds;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)resetOverlayView {
	if (_overlayView && !_overlayView.subviews.count) {
		[_overlayView removeFromSuperview];
		TT_RELEASE_SAFELY(_overlayView);
	}
}

- (void)layoutOverlayView {
	if (_overlayView) {
		_overlayView.frame = [self rectForOverlayView];
	}
}

#pragma mark -
#pragma mark Animation delegates

- (void)showAnimationDidStop {
	[[_launcherNavigationController topViewController] viewDidAppear:YES];
}

- (void)fadeAnimationDidStop {
	[self dismissChildAnimated:NO];
	TT_RELEASE_SAFELY(_overlayView);
}

- (void)fadeOut {
	UIView *viewToDismiss = [[_launcherNavigationController topViewController] view];

	viewToDismiss.transform = CGAffineTransformIdentity;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TT_LAUNCHER_HIDE_TRANSITION_DURATION];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidStop)];
	viewToDismiss.alpha = 0;		
	viewToDismiss.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
	_overlayView.alpha = 0.0f;
	[self resetOverlayView];
	[UIView commitAnimations];	
}


- (void)launchChild {
	UIView *viewToLaunch = [[_launcherNavigationController topViewController] view];
	
	viewToLaunch.transform = [self transformForOrientation];
	
	[self.superController.view addSubview:[_launcherNavigationController view]];
	_launcherNavigationController.superController = self;
	
	viewToLaunch.frame = self.view.bounds;
	viewToLaunch.alpha = 0;		
	viewToLaunch.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
		
	[[_launcherNavigationController topViewController] viewWillAppear:YES];

	// Add overlay view
	[self addOverlayView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TT_LAUNCHER_SHOW_TRANSITION_DURATION];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
	viewToLaunch.alpha = 1.0f;		
	viewToLaunch.transform = CGAffineTransformIdentity;
	_overlayView.alpha = 0.85f;
	[UIView commitAnimations];
		
}

- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
	if (!_launcherNavigationController) {
		_launcherNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
		_launcherNavigationController.superController = self;

		// Add default left-side button in navigation bar
		UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/launcher.png") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissChild)];
		[controller.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
		[launcherBarButtonItem release];

		// Launch child
		[self launchChild];
	} else {
		[_launcherNavigationController pushViewController:controller animated:animated];
	}
}

- (void)dismissChild {
	[self dismissChildAnimated:YES];
}

- (void)dismissChildAnimated:(BOOL)animated {
	if (animated) {
		[self fadeOut];
	} else {
		UIView *viewToDismiss = [_launcherNavigationController view];
		[viewToDismiss removeFromSuperview];
		TT_RELEASE_SAFELY(_launcherNavigationController);
		[self.superController viewWillAppear:animated];
		[self.superController viewDidAppear:animated];
	}
}

#pragma mark -
#pragma mark UIViewController (TTCategory)

- (void)persistNavigationPath:(NSMutableArray*)path {
	if (_launcherNavigationController) {
		// We have controllers open inside the launcher controller, so persist it
		[_launcherNavigationController persistNavigationPath:path];
	}
}


@end
