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

#import "BufferedReader.h"

#define NSBufferedReaderErrorDomain @"com.github.Yuri6037.TextTools.BufferedTextFile"

@interface BufferedReader()

- (BOOL)readBuffer;

@end

@implementation BufferedReader {
    NSFileHandle *_handle;
    NSMutableData *_buffer;
    ssize_t _cursor;
    ssize_t _len;
    int _fd;
    NSError *_error;
}

@synthesize readLineError = _error;

- (BufferedReader *)initWithDescriptor:(int)fd bufferSize:(NSUInteger)size error:(NSError **)error {
    _handle = nil;
    _fd = fd;
    _buffer = [NSMutableData dataWithLength:size];
    _cursor = 0;
    _len = 0;
    return self;
}

- (BufferedReader *)initWithHandle:(NSFileHandle *)file bufferSize:(NSUInteger)size error:(NSError **)error {
    _handle = file;
    _buffer = [NSMutableData dataWithLength:size];
    _cursor = 0;
    _len = 0;
    _fd = _handle.fileDescriptor;
    return self;
}

- (BOOL)readBuffer {
    ssize_t res = read(_fd, _buffer.mutableBytes, _buffer.length);
    if (res == -1) {
        _error = [NSError errorWithDomain:NSBufferedReaderErrorDomain code:errno userInfo:nil];
        return NO;
    }
    _cursor = 0;
    _len = res;
    return YES;
}

- (NSString * _Nullable)readLine {
    if (_fd == -1)
        return nil;
    NSString *line = nil;
    if (_cursor >= _len && ![self readBuffer])
        return nil;
    char *buffer = _buffer.mutableBytes;
    ssize_t i = _cursor;
    while (buffer[i] != '\n' && _len > 0) {
        i += 1;
        if (i >= _len) {
            NSUInteger len = i - _cursor;
            if (line == nil)
                //allocate a new line
                line = [[NSString alloc] initWithBytes:buffer + _cursor length:len encoding:NSUTF8StringEncoding];
            else
                //append to the line
                line = [line stringByAppendingString:[[NSString alloc] initWithBytes:buffer + _cursor length:len encoding:NSUTF8StringEncoding]];
            if (![self readBuffer])
                return nil;
            i = _cursor;
        }
    }
    if (i > _cursor) {
        NSUInteger len = i - _cursor;
        if (line == nil)
            //allocate a new line
            line = [[NSString alloc] initWithBytes:buffer + _cursor length:len encoding:NSUTF8StringEncoding];
        else
            //append to the line
            line = [line stringByAppendingString:[[NSString alloc] initWithBytes:buffer + _cursor length:i encoding:NSUTF8StringEncoding]];
        _cursor = i + 1; // skip the '\n'
    }
    if (buffer[_cursor] == '\n')
        _cursor += 1;
    return line;
}

- (void)close {
    if (_fd == -1)
        return;
    if (_handle != nil)
        [_handle closeFile];
    _fd = -1;
    _handle = nil;
}

- (void)dealloc {
    [self close];
}

@end
