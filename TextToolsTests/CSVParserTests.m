// Copyright 2022 Yuri6037
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy
// of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS
// IN THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "CSVParser.h"

@interface CSVParserTests : XCTestCase

@end

@implementation CSVParserTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testBasic {
    CSVParser *parser = [[CSVParser alloc] init:','];
    CSVRow array = [parser parseRow:@"number,42,\"this,is,a,test with \"\"\""];
    XCTAssertEqual(array.count, 3);
    XCTAssertEqualObjects([array objectAtIndex:0], @"number");
    XCTAssertEqualObjects([array objectAtIndex:1], @"42");
    XCTAssertEqualObjects([array objectAtIndex:2], @"this,is,a,test with \"");
}

- (void)testMoreQuotes {
    CSVParser *parser = [[CSVParser alloc] init:','];
    CSVRow array = [parser parseRow:@"\"test, \"\", test\"\"\""];
    XCTAssertEqual(array.count, 1);
    XCTAssertEqualObjects([array objectAtIndex:0], @"test, \", test\"");
}

- (void)testFrench {
    CSVParser *parser = [[CSVParser alloc] init:','];
    CSVRow array = [parser parseRow:@"accents,éè,ëê"];
    XCTAssertEqual(array.count, 3);
    XCTAssertEqualObjects([array objectAtIndex:0], @"accents");
    XCTAssertEqualObjects([array objectAtIndex:1], @"éè");
    XCTAssertEqualObjects([array objectAtIndex:2], @"ëê");
}

- (void)testChinese {
    CSVParser *parser = [[CSVParser alloc] init:','];
    CSVRow array = [parser parseRow:@"你好,我是,清华大学,的留学生"];
    XCTAssertEqual(array.count, 4);
    XCTAssertEqualObjects([array objectAtIndex:0], @"你好");
    XCTAssertEqualObjects([array objectAtIndex:1], @"我是");
    XCTAssertEqualObjects([array objectAtIndex:2], @"清华大学");
    XCTAssertEqualObjects([array objectAtIndex:3], @"的留学生");
}

- (void)testEmpty {
    CSVParser *parser = [[CSVParser alloc] init:','];
    CSVRow array = [parser parseRow:@"test,"];
    XCTAssertEqual(array.count, 2);
    XCTAssertEqualObjects([array objectAtIndex:0], @"test");
    XCTAssertEqualObjects([array objectAtIndex:1], @"");
}

@end
