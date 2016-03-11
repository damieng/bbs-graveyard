// MatrixOrbital LCD functions for BeOS

void MOSendText(char *Text);
void MOSendCode(char *Code, int Len);
void MOSetLineWrapping(bool LineWrap);
void MOSetScrolling(bool Scrolling);
void MOSetBacklight(bool Backlight);
void MOSetBlink(bool Blink);
void MOClearDisplay(void);
void MOSetContrast(int Contrast);
void MOSetCursorDisplay(int CursorDisplay);
void MOMoveCursorLeft(void);
void MOMoveCursorRight(void);
void MOCreateCustom(int Char, char Matrix[7]);
void MOSetGeneralPurpose(bool GeneralPurpose);
void MOSetCursorPosition(int Column, int Row);
void MOHome(void);
void MOInitLargeDigits(void);
void MOPlaceLargeDigit(int Column, char Digit);
void MOInitHorizBar(void);
void MOMakeHorizBar(int Column, int Row, int Dir, int Len);
void MOInitVertBar(int Thick);
void MOMakeVertBar(int Column, int Len);