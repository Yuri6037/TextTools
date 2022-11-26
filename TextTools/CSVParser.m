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

#import "CSVParser.h"

@implementation CSVParser {
    char _delimiter;
}

- (instancetype)init:(char)delimiter {
    _delimiter = delimiter;
    return self;
}

- (CSVRow)parseRow:(NSString *)row {
    bool quote = false;
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
    NSMutableData *curStr = [[NSMutableData alloc] init];
    const char *str = [row cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger i = 0;
    while (str[i]) {
        if (str[i] == '"') {
            if (i + 1 < row.length && str[i + 1] == '"') {
                //Double double-quotes
                [curStr appendBytes:"\"" length:1];
                ++i;
            } else
                quote = !quote;
        } else if (str[i] == _delimiter && !quote) {
            // We encountered a separator so create a new string.
            NSString *s = [[NSString alloc] initWithData:curStr encoding:NSUTF8StringEncoding];
            [array addObject:s];
            curStr = [[NSMutableData alloc] init];
        } else {
            //Just append the character to the array
            [curStr appendBytes:str + i length:1];
        }
        ++i;
    }
    NSString *s = [[NSString alloc] initWithData:curStr encoding:NSUTF8StringEncoding];
    [array addObject:s];
    return array;
}

@end
