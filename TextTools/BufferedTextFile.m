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

#include <fcntl.h>

#import "BufferedTextFile.h"

#define NSBufferedTextFileErrorDomain @"com.github.Yuri6037.TextTools.BufferedTextFile"

@implementation BufferedTextFile

- (BufferedTextFile * _Nullable)init:(NSString *)file bufferSize:(NSUInteger)size withError:(NSError **)error {
    const char *cfile = [file cStringUsingEncoding:NSUTF8StringEncoding];
    int fd = open(cfile, O_RDONLY);
    if (fd == -1) {
        *error = [NSError errorWithDomain:NSBufferedTextFileErrorDomain code:errno userInfo:nil];
        return nil;
    }
    return [super initWithDescriptor:fd bufferSize:size error:error];
}

- (NSString * _Nullable)readLine:(NSError **)error {
    NSString *line = [super readLine];
    if ([super readLineError] != nil)
        *error = [super readLineError];
    return  line;
}

@end
