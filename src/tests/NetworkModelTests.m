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

// See: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/905-A-Unit-Test_Result_Macro_Reference/unit-test_results.html#//apple_ref/doc/uid/TP40007959-CH21-SW2
// for unit test macros.

// See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>

// Mocks
#import "mocks/MockModelDelegate.h"

// Network
#import "Three20/TTModel.h"
#import "Three20/TTURLRequest.h"
#import "Three20/TTURLRequestModel.h"

// Core
#import "Three20/TTCorePreprocessorMacros.h"

/**
 * Unit tests for the Network model found within Three20. These tests are a part of
 * the comprehensive test suite for the Network functionality of the library.
 */

@interface NetworkModelTests : SenTestCase {
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NetworkModelTests


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testTTModel_init {
  TTModel* model = [[TTModel alloc] init];

  STAssertTrue(model.isLoaded, @"A TTModel is supposed to be loaded by default.");
  STAssertFalse(model.isLoading, @"A TTModel is not supposed to be loading by default.");
  STAssertFalse(model.isLoadingMore, @"A TTModel is not supposed to be loading more by default.");
  STAssertFalse(model.isOutdated, @"A TTModel is not supposed to be outdated by default.");

  TT_RELEASE_SAFELY(model);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testTTModel_delegate {
  TTModel* model = [[TTModel alloc] init];

  MockModelDelegate* mockResults = [[MockModelDelegate alloc] init];

  [model.delegates addObject:mockResults];

  // Successful loading
  {
    [model didStartLoad];
    STAssertTrue(mockResults.isLoading, @"The delegate is supposed to be loading now.");

    // The default model implementation doesn't provide any state, it's perpetually "loaded".
    STAssertFalse(model.isLoading, @"A TTModel is not supposed to be loading by default.");

    [model didFinishLoad];
    STAssertFalse(mockResults.isLoading, @"The delegate is supposed to be finished loading now.");
  }

  // Cancellation
  {
    [model didStartLoad];
    STAssertTrue(mockResults.isLoading, @"The delegate is supposed to be loading now.");

    [model didCancelLoad];
    STAssertFalse(mockResults.isLoading, @"The delegate is supposed to have canceled loading.");
  }

  // Failures
  {
    [model didStartLoad];
    STAssertTrue(mockResults.isLoading, @"The delegate is supposed to be loading now.");

    [model didFailLoadWithError:nil];
    STAssertTrue(mockResults.didFail, @"The delegate is supposed to have failed.");
  }

  TT_RELEASE_SAFELY(mockResults);
  TT_RELEASE_SAFELY(model);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLRequest


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)testTTURLRequestModel_defaultRequest {
  TTURLRequestModel* model = [[TTURLRequestModel alloc] init];

  NSBundle* testBundle = [NSBundle bundleWithIdentifier:@"com.facebook.three20.UnitTests"];
  STAssertTrue(nil != testBundle, @"Unable to find the bundle %@", [NSBundle allBundles]);

  NSString* xmlDataPath = [[testBundle bundlePath]
                           stringByAppendingPathComponent:@"testcase.xml"];

  TTURLRequest* request = [[TTURLRequest alloc] initWithURL:xmlDataPath delegate:nil];

  STAssertEquals(request.urlPath, xmlDataPath, @"The url path should equal the passed-in path.");

  STAssertNil(request.httpMethod, @"The default http method is nil.");
  STAssertNil(request.httpBody, @"The default http body is nil.");
  STAssertNil(request.contentType, @"The default content type is nil.");
  STAssertEquals([request.parameters count], (NSUInteger)0,
                 @"There should not be any parameters by default.");
  STAssertEquals([request.headers count], (NSUInteger)0,
                 @"There should not be any custom header properties by default.");
  STAssertEquals(request.cachePolicy, TTURLRequestCachePolicyDefault,
                 @"The cache policy by default, should be the default.");

  TT_RELEASE_SAFELY(model);
  TT_RELEASE_SAFELY(request);
}


@end
