/***********************************************************************************
 *
 * Copyright (c) 2010 Olivier Halligon
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 ***********************************************************************************
 *
 * Created by Olivier Halligon  (AliSoftware) on 20 Jul. 2010.
 *
 * Any comment or suggestion welcome. Please contact me before using this class in
 * your projects. Referencing this project in your AboutBox/Credits is appreciated.
 *
 ***********************************************************************************/


#import "NSAttributedString+Attributes.h"
#define FONT_SIZE 16.0f

/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: NS(Mutable)AttributedString Additions
/////////////////////////////////////////////////////////////////////////////

@implementation NSAttributedString (OHCommodityConstructors)
+(id)attributedStringWithString:(NSString*)string {
	return string ? [[self alloc] initWithString:string] : nil;
}
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr {
	return attrStr ? [[self alloc] initWithAttributedString:attrStr]  : nil;
}

-(CGSize)sizeConstrainedToSize:(CGSize)maxSize {
	return [self sizeConstrainedToSize:maxSize fitRange:NULL];
}
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange {
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
	CFRange fitCFRange = CFRangeMake(0,0);
	CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
	if (framesetter) CFRelease(framesetter);
	if (fitRange) *fitRange = NSMakeRange(fitCFRange.location, fitCFRange.length);
	return CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) ); // take 1pt of margin for security
}
@end




@implementation NSMutableAttributedString (OHCommodityStyleModifiers)

-(void) removeTokens: (NSString*) token {
    NSString *str = [self string];
    while (YES) {
        NSRange range = [str rangeOfString: token
                                   options: NSCaseInsensitiveSearch
                                     range: NSMakeRange(0,str.length)];
        if (!(range.location == NSNotFound)) {
            [self deleteCharactersInRange:range];
        } else break;
    }
    
}
-(void)setFont:(UIFont*)font {
	[self setFontName:font.fontName size:font.pointSize];
}
-(void)setFont:(UIFont*)font range:(NSRange)range {
	[self setFontName:font.fontName size:font.pointSize range:range];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size {
	[self setFontName:fontName size:size range:NSMakeRange(0,[self length])];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range {
	// kCTFontAttributeName
	CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)fontName, size, NULL);
	if (!aFont) return;
	[self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
	CFRelease(aFont);
}
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range {
	// kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
	CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
	NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait] forKey:(NSString*)kCTFontSymbolicTrait];
	NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
						  fontFamily,kCTFontFamilyNameAttribute,
						  trait,kCTFontTraitsAttribute,nil];
	
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attr);
	if (!desc) return;
	CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
	CFRelease(desc);
	if (!aFont) return;

	[self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
	CFRelease(aFont);
}

-(void)setTextColor:(UIColor*)color {
	[self setTextColor:color range:NSMakeRange(0,[self length])];
}
-(void)setTextColor:(UIColor*)color range:(NSRange)range {
	// kCTForegroundColorAttributeName
	[self removeAttribute:(NSString*)kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

-(void)setTextIsUnderlined:(BOOL)underlined {
	[self setTextIsUnderlined:underlined range:NSMakeRange(0,[self length])];
}
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range {
	int32_t style = underlined ? (kCTUnderlineStyleSingle|kCTUnderlinePatternSolid) : kCTUnderlineStyleNone;
	[self setTextUnderlineStyle:style range:range];
}
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range {
	[self removeAttribute:(NSString*)kCTUnderlineStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:style] range:range];
}

-(void)setTextBold:(BOOL)isBold range:(NSRange)range {
	NSUInteger startPoint = range.location;
	NSRange effectiveRange;
	do {
		// Get font at startPoint
		CTFontRef currentFont = (__bridge CTFontRef)[self attribute:(NSString*)kCTFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
		// The range for which this font is effective
		NSRange fontRange = NSIntersectionRange(range, effectiveRange);
		// Create bold/unbold font variant for this font and apply
		CTFontRef newFont = CTFontCreateCopyWithSymbolicTraits(currentFont, 0.0, NULL, (isBold?kCTFontBoldTrait:0), kCTFontBoldTrait);
		if (newFont) {
			[self removeAttribute:(NSString*)kCTFontAttributeName range:fontRange]; // Work around for Apple leak
			[self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)newFont range:fontRange];
			CFRelease(newFont);
		} else {
			NSString* fontName = (__bridge NSString*)CTFontCopyFullName(currentFont);
			NSLog(@"[OHAttributedLabel] Warning: can't find a bold font variant for font %@. Try another font family (like Helvetica) instead.",fontName);
		}
		////[self removeAttribute:(NSString*)kCTFontWeightTrait range:fontRange]; // Work around for Apple leak
		////[self addAttribute:(NSString*)kCTFontWeightTrait value:(id)[NSNumber numberWithInt:1.0f] range:fontRange];
		
		// If the fontRange was not covering the whole range, continue with next run
		startPoint = NSMaxRange(effectiveRange);
	} while(startPoint<NSMaxRange(range));
}

-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode {
	[self setTextAlignment:alignment lineBreakMode:lineBreakMode range:NSMakeRange(0,[self length])];
}
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range {
	// kCTParagraphStyleAttributeName > kCTParagraphStyleSpecifierAlignment
	CTParagraphStyleSetting paraStyles[2] = {
		{.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
		{.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 2);
	[self removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)aStyle range:range];
	CFRelease(aStyle);
}

@end

@implementation NSMutableAttributedString (DRSMethods)

-(NSMutableAttributedString *) changeAttrStr: (NSMutableAttributedString *) attrStr usingToken: (NSString *) token {
    NSRange myRange = NSMakeRange(0, attrStr.length);
    if ([token isEqualToString:@"##"]) { 
        [attrStr setTextIsUnderlined:YES range:myRange];
        [attrStr setTextBold:YES range:myRange];
    } else if ([token isEqualToString:@"$$"]) {
        [attrStr setTextBold:YES range:myRange];
    } else {
        [attrStr setTextIsUnderlined:YES range:myRange];
    }
    
    
    return attrStr;
    
}


-(NSMutableAttributedString *) modifyTextBetweenTokens  {
    NSString *str = [self string];
    NSRange rangeToSearchWithin = NSMakeRange(0, str.length);
    NSRange tempRange = NSMakeRange(0, 0);
    NSRange searchResult;
    int newLocationToStartAt=0;
    int cont=-1;
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:str];
    NSArray *array = [[NSArray alloc] initWithObjects:@"##", @"$$", @"**", nil];
    
    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE]];
    
    
    for (NSString *token in array) {
        while (YES) {
            cont++;
            if (cont>0) {
                tempRange=searchResult;
            }
            
            searchResult = [str rangeOfString: token
                                      options: NSCaseInsensitiveSearch
                                        range: rangeToSearchWithin];
            if (!(searchResult.location == NSNotFound)) {
                
                
                if (cont>0) {
                    int location = tempRange.location;
                    int length = searchResult.location - location + token.length;
                    
                    tempRange.length = length;
                    NSAttributedString *temp = [attrStr attributedSubstringFromRange:tempRange];
                    NSMutableAttributedString *subStr = [temp mutableCopy];
                    
                    subStr = [self changeAttrStr:subStr usingToken:token];
                    
                    tempRange = NSMakeRange(newLocationToStartAt-token.length, length);
                    [attrStr replaceCharactersInRange:tempRange withAttributedString:subStr];
                    
                    cont = -1;
                    tempRange = NSMakeRange(0, 0);
                }
                
            } else {
                rangeToSearchWithin = NSMakeRange(0, str.length);
                tempRange = NSMakeRange(0, 0);
                cont=-1;
                break;  
            }     
            
            if (str.length - newLocationToStartAt <= token.length ) {
                rangeToSearchWithin = NSMakeRange(0, str.length);
                tempRange = NSMakeRange(0, 0);
                cont =-1;
                break;
            }
            
            newLocationToStartAt = searchResult.location + token.length;
            rangeToSearchWithin = NSMakeRange(newLocationToStartAt, str.length - newLocationToStartAt);
        }
        [attrStr removeTokens:token];
    }
    return attrStr;

}
@end

@implementation NSAttributedString (DRSConstructorsMethods) 

+(id) attributedStringWithStringModifiedByTokens: (NSString *) str {
    id attrStr =  [[NSMutableAttributedString alloc] initWithString:str];
    NSRange rangeToSearchWithin = NSMakeRange(0, str.length);
    NSRange tempRange = NSMakeRange(0, 0);
    NSRange searchResult;
    int newLocationToStartAt=0;
    int cont=-1;
    NSArray *array = [[NSArray alloc] initWithObjects:@"##", @"$$", @"**", nil];
    
    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:FONT_SIZE]];
    
    
    for (NSString *token in array) {
        while (YES) {
            cont++;
            if (cont>0) {
                tempRange=searchResult;
            }
            
            searchResult = [str rangeOfString: token
                                      options: NSCaseInsensitiveSearch
                                        range: rangeToSearchWithin];
            if (!(searchResult.location == NSNotFound)) {
                
                
                if (cont>0) {
                    int location = tempRange.location;
                    int length = searchResult.location - location + token.length;
                    
                    tempRange.length = length;
                    NSAttributedString *temp = [attrStr attributedSubstringFromRange:tempRange];
                    NSMutableAttributedString *subStr = [temp mutableCopy];
                    
                    subStr = [attrStr changeAttrStr:subStr usingToken:token];
                    
                    tempRange = NSMakeRange(newLocationToStartAt-token.length, length);
                    [attrStr replaceCharactersInRange:tempRange withAttributedString:subStr];
                    
                    cont = -1;
                    tempRange = NSMakeRange(0, 0);
                }
                
            } else {
                rangeToSearchWithin = NSMakeRange(0, str.length);
                tempRange = NSMakeRange(0, 0);
                cont=-1;
                break;  
            }     
            
            if (str.length - newLocationToStartAt <= token.length ) {
                rangeToSearchWithin = NSMakeRange(0, str.length);
                tempRange = NSMakeRange(0, 0);
                cont =-1;
                break;
            }
            
            newLocationToStartAt = searchResult.location + token.length;
            rangeToSearchWithin = NSMakeRange(newLocationToStartAt, str.length - newLocationToStartAt);
        }
        [attrStr removeTokens:token];
    }
    return attrStr;

}

@end

