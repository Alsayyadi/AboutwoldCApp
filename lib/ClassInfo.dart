import 'package:flutter/material.dart';

class GetSize {
  double pageHeight,
      pageWidth,
      fontPrimary,
      fontSecondary,
      fontThird,
      paddingAll,
      paddingTop,
      paddingBottom,
      paddingRight,
      paddingLeft,
      iconSize,
      fontSizeIconMain,
      fontSizeIcon;

  GetSize(context) {
    double mediaHeight = pageHeight = MediaQuery.of(context).size.height;
    double mediaWidth = pageWidth = MediaQuery.of(context).size.width;
    this.pageHeight = MediaQuery.of(context).size.height;
    this.pageWidth = MediaQuery.of(context).size.width;
    this.paddingAll = (mediaHeight * 0.02 + mediaWidth * 0.02) / 2;
    this.paddingTop = mediaHeight * 0.01;
    this.paddingBottom = mediaHeight * 0.01;
    this.paddingRight = mediaWidth * 0.01;
    this.paddingLeft = mediaWidth * 0.01;
    if (mediaHeight > 800) {
      this.fontPrimary = 27;
      this.fontSecondary = 23;
      this.iconSize = 30;
      this.fontSizeIconMain = 320;
      this.fontSizeIcon = 60;
    } else if (mediaHeight > 750) {
      this.fontPrimary = 22;
      this.fontSecondary = 17;
      this.iconSize = 25;
      this.fontSizeIconMain = 250;
      this.fontSizeIcon = 45;
    } else if (mediaHeight > 700) {
      this.fontPrimary = 21;
      this.fontSecondary = 16;
      this.iconSize = 24;
      this.fontSizeIconMain = 240;
      this.fontSizeIcon = 43;
    } else if (mediaHeight > 650) {
      this.fontPrimary = 20;
      this.fontSecondary = 15;
      this.iconSize = 23;
      this.fontSizeIconMain = 230;
      this.fontSizeIcon = 41;
    } else if (mediaHeight > 600) {
      this.fontPrimary = 19;
      this.fontSecondary = 14;
      this.iconSize = 22;
      this.fontSizeIconMain = 220;
      this.fontSizeIcon = 39;
    } else if (mediaHeight > 550) {
      this.fontPrimary = 18;
      this.fontSecondary = 13;
      this.iconSize = 21;
      this.fontSizeIconMain = 210;
      this.fontSizeIcon = 37;
    } else if (mediaHeight > 500) {
      this.fontPrimary = 17;
      this.fontSecondary = 12;
      this.iconSize = 20;
      this.fontSizeIconMain = 200;
      this.fontSizeIcon = 35;
    }
  }


}
