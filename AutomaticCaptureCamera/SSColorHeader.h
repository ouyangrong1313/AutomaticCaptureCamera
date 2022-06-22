//
//  SSColorHeader.h
//  小蚁学堂
//
//  Created by 刘辉 on 2018/2/5.
//  Copyright © 2018年 Liew. All rights reserved.
//

#ifndef SSColorHeader_h
#define SSColorHeader_h

#define COLOR_E2E2E2    0xe2e2e2
#define COLOR_FAFAFA    0xfafafa
#define COLOR_EDEDED    0xededed
#define COLOR_CCCCCC    0xcccccc
#define COLOR_46C390    0x46c390
#define COLOR_C3E5D5    0xc3e5d5
#define COLOR_FFFFFF    0xffffff //白色
#define COLOR_DCDCDC    0xdcdcdc
#define COLOR_8CC63F    0x8cc63f
#define COLOR_7E7E7E    0x7e7e7e
#define COLOR_F4F4F4    0xf4f4f4
#define COLOR_393939    0x393939 //黑色字体
#define COLOR_6B3B55    0x6b3b55
#define COLOR_BFBFBF    0xbfbfbf
#define COLOR_EE0A3A    0xee0a3a
#define COLOR_DCDCDC    0xdcdcdc
#define COLOR_6B3B55    0x6b3b55
#define COLOR_ECECEC    0xececec
#define COLOR_000000    0x000000 //黑色
#define COLOR_FF6465    0xFF6465 //红色
#define COLOR_E3E4EE    0xE3E4EE
#define COLOR_7C819D    0x7C819D //灰色字体（夜间模式）
#define COLOR_5E6CE3    0x5E6CE3
#define COLOR_F1F3FA    0xF1F3FA //灰色背景(白天模式)
#define COLOR_6AA3F8    0x6AA3F8
#define COLOR_666666    0x666666
#define COLOR_F4F6FB    0xF4F6FB //文本灰色背景
#define COLOR_778ADC    0x778ADC //蓝色字体
#define COLOR_333333    0x333333
#define COLOR_8489A3    0x8489A3
#define COLOR_1B1B29    0x1B1B29 //灰色背景（夜间模式）
#define COLOR_D0D5E6    0xD0D5E6 //灰色线条（白天模式）
#define COLOR_494F57    0x494F57 //灰色线条（夜间模式）
#define COLOR_6274CC    0x6274CC //蓝色字体
#define COLOR_4B87EF    0x4B87EF //蓝色字体 - 登录密码
#define COLOR_7C819C    0x7C819C
#define COLOR_F1F3F9    0xF1F3F9
#define COLOR_7B819D    0x7B819D
#define COLOR_E5E5E5    0xE5E5E5
#define COLOR_CFD5E5    0xCFD5E5
#define COLOR_516BE3    0x516BE3
#define COLOR_1C1C2A    0x1C1C2A
#define COLOR_3A3A3A    0x3a3a3a
#define COLOR_7C829E    0x7C829E
#define COLOR_232323    0x232323    // 灰色背景（暗黑模式）
#define COLOR_4A9AE3    0x4A9AE3    // 淡灰背景
#define COLOR_555555    0x555555    // 淡灰色边框（暗黑模式）
#define COLOR_2740C5    0x2740C5    // 蓝色背景
#define COLOR_111111    0x111111    // 黑色背景（暗黑模式）
#define COLOR_131313    0x131313
#define COLOR_F5F5F5    0xF5F5F5
#define COLOR_FF6466    0xFF6466
#define COLOR_4B87EF    0x4B87EF
#define COLOR_B0B5CF    0xB0B5CF
#define COLOR_F2F5FF    0xF2F5FF
#define COLOR_222222    0x222222
#define COLOR_FD6568    0xFD6568
#define COLOR_6F5024    0x6F5024
#define COLOR_F8FAFE    0xF8FAFE
#define COLOR_F1F1F1    0xF1F1F1
#define COLOR_181818    0x181818
#define COLOR_262929    0x262929
#define COLOR_1A1919    0x1A1919
#define COLOR_F2F2F2    0xF2F2F2
#define COLOR_A2A2A2    0xA2A2A2
#define COLOR_F0F0F5    0xF0F0F5
#define COLOR_E9F3FF    0xE9F3FF
#define COLOR_1B6CFF    0x1B6CFF
#define COLOR_C4C7CC    0xC4C7CC
#define COLOR_535D7B    0x535D7B

//色码转RGB UIColor
#undef UIColorFromHex

#define UIColorFromRGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromHex(hexValue) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:1.0])
//附带透明度
#undef UIColorFromHexA
#define UIColorFromHexA(hexValue,a) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:(a)])

//UITextField.placeholder 默认颜色值
#undef TextFieldplaceColor
#define TextFieldplaceColor ([UIColor colorWithRed:0 green:0 blue:0.098039 alpha:0.22])


#define WebViewProgress_TintColor ([UIColor colorWithRed:65/255.0f green:139/255.0f blue:235/255.0f alpha:1.0f])

/**
 *  字体的大小
 */
#undef FONTWITHNAME
#define FONTWITHNAME(fontName,fontSize)    ([UIFont fontWithName:fontName size:fontSize])

#define WIDTH6                  375.0
#define XX_6(value)             (1.0 * (value) * kFullScreenWidth / WIDTH6)
//系统默认字体   设置字体的大小
#undef FONTDEFAULT
#define FONTDEFAULT(value)            ([UIFont systemFontOfSize:ceil(XX_6(value))])
//系统加粗字体   设置字体的大小

// 系统常见的两种字体
#define FONT_Medium(value)  [UIFont fontWithName:@"PingFang-SC-Medium" size:value]
#define FONT_Semibold(value)  [UIFont fontWithName:@"PingFangSC-Semibold" size:value]


#undef FONTBOLD
//#define FONTBOLD(value)            ([UIFont systemFontOfSize:ceil(XX_6(value))])
//#define FONTBOLD(value)             [UIFont systemFontOfSize:value]
#define FONTBOLD(fontSize)            ([UIFont boldSystemFontOfSize:fontSize])
#define ScreenGridViewHeight    (1/[UIScreen mainScreen].scale)

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
#define KFitScaleIPhone6 kFullScreenWidth / 375.0

#endif /* SSColorHeader_h */
