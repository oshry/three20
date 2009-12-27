//
//  TTSegmentedViewController.h
//  Three20
//
//  Created by Rodrigo Mazzilli on 10/29/09.
//

#import "Three20/TTViewController.h"

@class TTSegmentedToolbar;

@interface TTSegmentedViewController : TTViewController {
	NSMutableArray *_viewControllers;
	TTSegmentedToolbar *_segmentedToolbar;	
	
	NSInteger _visibleViewControllerIndex;
}
@property (nonatomic, readonly) NSArray *viewControllers;

@end
