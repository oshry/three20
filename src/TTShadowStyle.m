//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20/TTShadowStyle.h"

// Style
#import "Three20/TTGlobalStyle.h"
#import "Three20/TTStyleContext.h"
#import "Three20/TTShape.h"

// Core
#import "Three20/TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTShadowStyle

@synthesize color   = _color;
@synthesize blur    = _blur;
@synthesize offset  = _offset;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNext:(TTStyle*)next {
  if (self = [super initWithNext:next]) {
    _offset = CGSizeZero;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_color);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTShadowStyle*)styleWithColor:(UIColor*)color blur:(CGFloat)blur offset:(CGSize)offset
                            next:(TTStyle*)next {
  TTShadowStyle* style = [[[self alloc] initWithNext:next] autorelease];
  style.color = color;
  style.blur = blur;
  style.offset = offset;
  return style;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTStyle


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)draw:(TTStyleContext*)context {
  CGFloat blurSize = round(_blur / 2);
  UIEdgeInsets inset = UIEdgeInsetsMake(blurSize, blurSize, blurSize, blurSize);
  if (_offset.width < 0) {
    inset.left += fabs(_offset.width) + blurSize*2;
    inset.right -= blurSize;
  } else if (_offset.width > 0) {
    inset.right += fabs(_offset.width) + blurSize*2;
    inset.left -= blurSize;
  }
  if (_offset.height < 0) {
    inset.top += fabs(_offset.height) + blurSize*2;
    inset.bottom -= blurSize;
  } else if (_offset.height > 0) {
    inset.bottom += fabs(_offset.height) + blurSize*2;
    inset.top -= blurSize;
  }

  context.frame = TTRectInset(context.frame, inset);
  context.contentFrame = TTRectInset(context.contentFrame, inset);

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);

  [context.shape addToPath:context.frame];

// Rodrigo: Fix the shadow issue in TTLauncherItem as discussed here
// http://groups.google.com/group/three20/browse_thread/thread/ff57fb6347ec3b7e/b50f33ff39f5f5a1?lnk=gst&q=TTLauncherItem+badge#b50f33ff39f5f5a1
  CGContextSetShadowWithColor(ctx, CGSizeMake(_offset.width, _offset.height), _blur, 
								_color.CGColor); 

  CGContextBeginTransparencyLayer(ctx, nil);
  [self.next draw:context];
  CGContextEndTransparencyLayer(ctx);

  CGContextRestoreGState(ctx);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  CGFloat blurSize = round(_blur / 2);
  size.width += _offset.width + (_offset.width ? blurSize : 0) + blurSize*2;
  size.height += _offset.height + (_offset.height ? blurSize : 0) + blurSize*2;

  if (_next) {
    return [self.next addToSize:size context:context];
  } else {
    return size;
  }
}


@end
