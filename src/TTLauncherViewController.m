//
//  TTLauncherViewController.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.


#import "Three20/TTLauncherViewController.h"

#import "Three20/Three20.h"
#import "Three20/TTDefaultStyleSheet.h"
#import "Three20/TTURLCache.h"

#define TTLAUNCHERVIEW_MAX_SIZE		CGSizeMake(320.0f, 426.0f)

@interface TTLauncherViewController (Private)
- (void)removeFromSupercontroller:(BOOL)animated;
@end


@implementation TTLauncherViewController

@synthesize launcherNavigationController = _launcherNavigationController;
@synthesize launcherView = _launcherView;

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
		_overlayView = nil;
		_launcherNavigationControllerTopViewController = nil;
	}
	return self;
}

#pragma mark -
#pragma mark UITableViewController

- (void)loadView {
	[super loadView];	
	_launcherView = [[TTLauncherView alloc] initWithFrame:self.view.frame];
	_launcherView.backgroundColor = TTSTYLEVAR(launcherBackgroundColor);
	[self.view addSubview:_headerView];
	[self.view addSubview:_launcherView];
	[self.view addSubview:_footerView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// We should NOT call this for _launcherNavigationController
	// otherwise the transition calls viewWillAppear: and viewDidAppear:
	// won't be called by the navigation controller.
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	// We should NOT call this for _launcherNavigationController
	// otherwise the transition calls viewWillAppear: and viewDidAppear:
	// won't be called by the navigation controller.	
}

- (CGAffineTransform)transformForOrientation {
	return TTRotateTransformForOrientation(TTInterfaceOrientation());
}

#pragma mark -
#pragma mark Overlay view

- (CGRect)rectForOverlayView {
	return [self.view frameWithKeyboardSubtracted:0];
}

- (void)addOverlayView {
	if (!_overlayView) {
		CGRect frame = [self rectForOverlayView];
		_overlayView = [[UIView alloc] initWithFrame:frame];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.alpha = 0.0f;
		_overlayView.autoresizesSubviews = YES;
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		[self.view addSubview:_overlayView];
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
	// Notify super controller that it did disappear, since
	// a child was launched on top.
	[self viewDidDisappear:YES];
}

- (void)fadeAnimationDidStop {
	[[_launcherNavigationController topViewController] viewDidDisappear:YES];
	[self removeFromSupercontroller:NO];
	[self resetOverlayView];
}

- (void)fadeOut {
	[[_launcherNavigationController topViewController] viewWillDisappear:YES];
	
	UIView *viewToDismiss = [[_launcherNavigationController topViewController] view];
	viewToDismiss.transform = CGAffineTransformIdentity;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TT_LAUNCHER_HIDE_TRANSITION_DURATION];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidStop)];
	viewToDismiss.alpha = 0;		
	viewToDismiss.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
	_overlayView.alpha = 0.0f;
	[UIView commitAnimations];	
}


- (void)launchChild {
	// Notify super controller that it will disappear, since
	// a child will be launched on top.
	[self viewWillDisappear:YES];
	
	UIView *viewToLaunch = [[_launcherNavigationController topViewController] view];
	
	// Hide keyboard if visible
	UIResponder *firstResponder = [[[UIApplication sharedApplication] keyWindow] findFirstResponder]; 
	[firstResponder resignFirstResponder];
	
	viewToLaunch.transform = [self transformForOrientation];
	
	[self.superController.view addSubview:[_launcherNavigationController view]];
	
	viewToLaunch.frame = self.view.bounds;
	viewToLaunch.alpha = 0;		
	viewToLaunch.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
	
	// Add overlay view
	[self addOverlayView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TT_LAUNCHER_SHOW_TRANSITION_DURATION];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
	viewToLaunch.alpha = 1.0f;		
	viewToLaunch.transform = CGAffineTransformIdentity;
	_overlayView.alpha = 0.85f;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UIViewController (TTCategory)

- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
	if (!_launcherNavigationController) {
		_launcherNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
		[_launcherNavigationController viewWillAppear:animated];
		[_launcherNavigationController viewDidAppear:animated];
		
		_launcherNavigationController.superController = self;
		
		// Add default left-side button in navigation bar
		UIBarButtonItem *launcherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/launcher.png")
												  style:UIBarButtonItemStyleBordered
												  target:self
												  action:@selector(removeFromSupercontroller)];
		[controller.navigationItem setLeftBarButtonItem:launcherBarButtonItem];
		[launcherBarButtonItem release];
		
		// Launch child
		[self launchChild];
		
	} else {
		[_launcherNavigationController addSubcontroller:controller animated:animated transition:transition];
	}
}

- (void)removeFromSupercontroller:(BOOL)animated {
	if (animated) {
		[self fadeOut];
	} else {
		[_launcherNavigationController.topViewController removeFromSupercontroller];
		[[_launcherNavigationController view] removeFromSuperview];
		// We need to keep this navigation controller
		// so that notifications viewWillAppear: and viewDidAppear:
		// continue to be dispatched.
		// Since we cannot fully remove the top view controller from
		// navigation controller, we set a 'nil' array. 
		if ([_launcherNavigationController.viewControllers count] == 1) {
			TT_RELEASE_SAFELY(_launcherNavigationController);
		}
		_launcherNavigationControllerTopViewController = nil;
		[self.superController viewWillAppear:animated];
		[self.superController viewDidAppear:animated];
	}
}

- (void)removeFromSupercontroller {
	[self removeFromSupercontroller:YES];
}

- (void)persistNavigationPath:(NSMutableArray*)path {
	if (_launcherNavigationController) {
		// We have controllers open inside the launcher controller, so persist it
		[_launcherNavigationController persistNavigationPath:path];
	}
}

- (UIViewController *)topSubcontroller {
	return _launcherNavigationControllerTopViewController;
}

#pragma mark -
#pragma mark Layout subviews

- (void)layoutSubviews {
	CGFloat headerHeight = 0.0f;
	CGFloat footerHeight = 0.0f;
	if (_headerView) {
		[_headerView setFrame:CGRectMake(0.0f, 0.0f, _headerView.frame.size.width,  _headerView.frame.size.height)];
		headerHeight = _headerView.frame.size.height;
	}
	
	if (_footerView) {
		footerHeight = _footerView.frame.size.height;
		[_footerView setFrame:CGRectMake(0.0f, self.view.bounds.size.height - footerHeight, _footerView.frame.size.width,  footerHeight)];
	}	
	[self.view addSubview:_headerView];
	[self.view addSubview:_footerView];
	[_launcherView setFrame:CGRectMake(0.0f, headerHeight, 320.0f, TTLAUNCHERVIEW_MAX_SIZE.height - footerHeight)];
}

#pragma mark -
#pragma mark Public

- (void)setHeaderView:(UIView *)headerView {
	TT_RELEASE_SAFELY(_headerView);
	_headerView = [headerView retain];
	[self layoutSubviews];
}

- (UIView *)headerView {
	return _headerView;
}

- (void)setFooterView:(UIView *)footerView {
	TT_RELEASE_SAFELY(_footerView);
	_footerView = [footerView retain];
	[self layoutSubviews];
}

- (UIView *)footerView {
	return _footerView;
}

@end
