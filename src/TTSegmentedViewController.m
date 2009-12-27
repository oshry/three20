//
//  TTSegmentedViewController.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 10/29/09.
//

#import "TTSegmentedViewController.h"

#import "Three20/Three20.h"
#import "Three20/TTSegmentedToolbar.h"

@implementation TTSegmentedViewController

@synthesize viewControllers = _viewControllers;

- (void)dealloc {
	TT_RELEASE_SAFELY(_viewControllers);
	[super dealloc];
}

- (id)initWithSegments:(NSArray *)viewControllers {
	if (self = [super init]) {
		_viewControllers = [viewControllers retain];
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	// Obtain view controller titles
	NSArray *titles = [_viewControllers valueForKeyPath:@"@distinctUnionOfObjects.title"];
	
	// Initialize TTSegmentedToolbar
	_segmentedToolbar = [[TTSegmentedToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - TTToolbarHeight(), self.view.width, TTToolbarHeight())];
	[_segmentedToolbar setSegmentedItems:titles];
	
	[self.view setFrame:TTToolbarNavigationFrame()];
}


- (void)viewDidLoad {
	_segmentedToolbar.segmentedControl.selectedSegmentIndex = 0;
}

@end
